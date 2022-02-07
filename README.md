# WG Server
A WireGuard server running in AWS in a Free Tier account.

## Set up
1. [Create a new AWS account](https://portal.aws.amazon.com/billing/signup#/start)
2. Create a pair of [keys](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/)
3. Install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configure a named profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
4. [Install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Usage
Track free tier usage https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/tracking-free-tier-usage.html

1. Get the repo
   1. Optionally re-configure region and profile for provider
3. Deploy infrastructure
```bash
terraform apply
```
4. Start the server
```bash
terraform apply -var state="on" -auto-approve
```
5. Get a config file with the command outputted and configure your WG client. You may need to wait a min for the server set up completion
```
Outputs:
cli = "aws --profile personal s3 cp s3://personal-bucket-115-das-rich-joe/config.yaml config.yaml && cat config.yaml"
```
6. Stop the server
```bash
terraform apply -var state="off" -auto-approve
```

## Troubleshooting
Server is accessible through Session Manager
```bash
alias connect_to_server="aws --profile personal ssm start-session --target `aws ec2 --profile personal describe-instances --filters "Name=tag-value,Values=wg" --filters Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].{Instance:InstanceId}' --output text`"
```
## Terraform docs
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_profile"></a> [profile](#input\_profile) | awscli profile name | `string` | `"personal"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region | `string` | `"eu-west-1"` | no |
| <a name="input_state"></a> [state](#input\_state) | State of the WG server | `string` | `"off"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cli"></a> [cli](#output\_cli) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
