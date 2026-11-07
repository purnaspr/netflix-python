resource "aws_vpc" "purna"{
    cidr_block =var.vpc_cidr
    enable_dns_hostnames = true

    tags ={
        Name = "purna-vpc"
    }
}

resource "aws_subnet" "public"{
    vpc_id = aws_vpc.purna.id
    cidr_block = var.subnet_cidr
    availability_zone = var.availabelity_zone

    tags={
        Name ="public-subnet"
    }
}

resource "aws_internet_gateway" "gw"{
    vpc_id = aws_vpc.purna.id

    tags= {
        Name = "purna-igw"
    }
}

resource "aws_route_table" "public"{
    vpc_id = aws_vpc.purna.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags={
        Name = "purna-public"
    }
}

resource "aws_route_table_association" "public"{
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "purna_sg"{
    vpc_id = aws_vpc.purna.id
    name = "purna-sg"

    ingress{
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol ="tcp"
        cidr_blocks =[var.my_ip]
    }

    ingress {
        description = "docjen"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags ={
        Name = "purna-sg"
    }
}

resource "aws_instance" "new_project"{
    for_each = var.servers
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.purna_sg.id]
    associate_public_ip_address = true

    tags ={
        Name = each.value
    }
}