
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "terraform_dev_vpc"
    cidr = "10.0.0.0/16"

    azs = ["eu-west-1a", "eu-west-1b"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

    #By having a public subnet an Internet gateway/routes are added automatically
    enable_nat_gateway = true

    tags = {
        Terraform = "true"
        Environment = "dev"
    }

}