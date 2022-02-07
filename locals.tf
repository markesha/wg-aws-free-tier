locals {
  cidr_block           = "10.0.0.0/16"
  public_subnet_ranges = ["10.0.4.0/24", "10.0.5.0/24"]

  tags = {
    region = var.region
  }
}
