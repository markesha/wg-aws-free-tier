resource "random_pet" "this" {
  length = 3
}

resource "aws_s3_bucket" "this" {
  bucket = "personal-bucket-115-${random_pet.this.id}"
  acl    = "private"

  tags          = local.tags
  force_destroy = true
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "this" {
  name_prefix     = "wg"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.ec2.id]
  user_data = templatefile(
    "${path.module}/files/user-data.sh.tftpl",
    { bucket = aws_s3_bucket.this.bucket }
  )
  iam_instance_profile = aws_iam_instance_profile.this.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  max_size                  = 1
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.state == "on" ? 1 : 0
  launch_configuration      = aws_launch_configuration.this.name
  vpc_zone_identifier       = [for subnet in aws_subnet.public : subnet.id]

  tag {
    key                 = "Name"
    value               = "wg"
    propagate_at_launch = true
  }
}
