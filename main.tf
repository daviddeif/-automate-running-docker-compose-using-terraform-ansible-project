provider "aws" {
  shared_credentials_files = ["~/Desktop/mycredentials"]
  profile                  = "default"
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = var.cidr

  tags = {
    Name = "app-vpc"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.public-subnet-cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.route_table_cidr
  gateway_id             = aws_internet_gateway.igw.id
}


# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}


resource "aws_instance" "control_instance" {
  ami             = "ami-007855ac798b5175e" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name = "iti"
  vpc_security_group_ids = [aws_security_group.sg.id]
  depends_on = [
    aws_instance.managed_instance 
  ]
  connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/Desktop/iti.pem")
      host = self.public_ip

    }
  provisioner "file" {
   source = "myplaybook.yaml" 
   destination = "/home/ubuntu/myplaybook.yaml"
  
  }
  provisioner "file" {
   source = "instance_ip.txt" 
   destination = "/home/ubuntu/instance_ip"
  }
  provisioner "file" {
   source = "/home/david/Desktop/iti.pem" 
   destination = "/home/ubuntu/iti.pem"
  }
  provisioner "file" {
    source = "docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y software-properties-common",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get install -y ansible",
      "chmod 400 ~/iti.pem",
      "ansible-playbook -i /home/ubuntu/instance_ip /home/ubuntu/myplaybook.yaml --ssh-extra-args='-o StrictHostKeyChecking=no'"
    ]
  }
  tags = {
    Name = "control_instance"
  }

  volume_tags = {
    Name = "control_instance"
  } 
}

resource "aws_instance" "managed_instance" {
  ami             = "ami-06e46074ae430fba6" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  key_name = "iti"
  associate_public_ip_address = true

  provisioner "local-exec" {
    command = "echo -n ${aws_instance.managed_instance.public_ip} > instance_ip.txt && echo ' ansible_ssh_private_key_file=~/iti.pem  ansible_user=ec2-user' >> instance_ip.txt"
  }

  vpc_security_group_ids = [aws_security_group.sg.id]
  
  tags = {
    Name = "managed_instance"
  }

  volume_tags = {
    Name = "public_instance"
  } 
}
