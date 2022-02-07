provider "aws" {
  region  = "eu-west-1"
  profile = "personal"
}

module "example" {
  source = "../"
}
