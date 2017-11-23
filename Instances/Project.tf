
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

resource "aws_instance" "example" {
    ami        = "${lookup(var.amis, var.region)}" # Points to an AMI I created with Python, Django, uWSGI and Nginx preinstalled
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-c97a71b0", "sg-c97a71b0"]

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
