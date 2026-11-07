variable "aws_region"{
    type = string
    default = "us-east-1"
}

variable "vpc_cidr"{
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_cidr"{
    type = string
    default = "10.0.1.0/24"
}

variable "availabelity_zone"{
    type = string
    default = "us-east-1a"
}

variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "key_name" {
    type = string
    default = "purna"
}

variable "servers" {
    type = set(string)
    default = ["ansible", "docjen"]
}

variable "my_ip"{
    type = string
    default = "0.0.0.0/0"
}