
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

resource "aws_instance" "example" {
    ami        = "${lookup(var.amis, var.region)}"
    instance_type = "t2.micro"

    tags {
        Name = "Terraform_Tutorial"
    }

    provisioner "local-exec" {
        command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
    }
}

resource "aws_eip" "ip" {
    instance = "${aws_instance.example.id}"
}


output "ip" {
    value = "${aws_eip.ip.public_ip}"
}

module "managment-vpc" {
  #source = "git::ssh://git@bitbucket.org/digitalrigbitbucketteam/digitalrig-iaas-modules.git//terraform/modules/aws/network"
  source = "../modules/aws/rig-3/network"
  region = "${var.region}"
  name = "${var.rigname}"
  ansible-domain="${var.rigname}"
  vpc_cidr        = "${var.config["vpc-net-cidr"]}"
  azs             = "${split(",", var.config["availability-zones"])}" # AZs are region specific
  private_subnets = "${split(",", var.config["internal-net-cidrs"])}" # Creating one private subnet per AZ
  public_subnets  = "${split(",", var.config["dmz-net-cidrs"])}" # Creating one public subnet per AZ
  owner = "${data.aws_caller_identity.current.arn}"
}