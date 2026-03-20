terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

#configure aws provider
provider "aws"{
    region ="us-east-2"
}

#create vpc
resource "aws_vpc" "mylab-vpc" {
    cidr_block = var.cidr_block[0]
    tags = {
        Name = "mylab-vpc"
    }
}
#create subnet
resource "aws_subnet" "mylab-subnet1" {
    vpc_id = aws_vpc.mylab-vpc.id
    cidr_block =var.cidr_block[1]

    tags={
        Name="mylab-subnet1"
    }
}

#create internet gateway

resource aws_internet_gateway "mylab-internetgateway"{
    vpc_id =aws_vpc.mylab-vpc.id
    tags={
        Name="mylab-internetgateway"
    }
}

#create security group
resource "aws_security_group" "mylab-sec_group"{
    name= "mylab security group"
    description="to allow inbound and outboundd traffic to mylab"
    vpc_id = aws_vpc.mylab-vpc.id

    dynamic ingress{
        iterator =port
        for_each = var.ports
        content {
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks= ["0.0.0.0/0"]
          }
    }
    egress{
        from_port =0
        to_port =0
        protocol = "-1"
        cidr_blocks= ["0.0.0.0/0"]
    }
    tags={
        Name ="allow traffic"
    }
}

resource "aws_route_table" "mylab_routetable"{
    vpc_id = aws_vpc.mylab-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.mylab-internetgateway.id
    }     
    tags={
        Name="mylab_routetable"
    }
}

resource "aws_route_table_association" "my_lab_association"{
    subnet_id = aws_subnet.mylab-subnet1.id
    route_table_id = aws_route_table.mylab_routetable.id
}



resource "aws_instance" "jenkins"{
    ami = var.ami
    instance_type = var.instance_type
    key_name = "EC2"
    vpc_security_group_ids = [aws_security_group.mylab-sec_group.id]
    subnet_id = aws_subnet.mylab-subnet1.id 
    associate_public_ip_address = true
    user_data = file("./installjenkins.sh")
    tags = {
      Name = "jenkins-server" 
    }
}

resource "aws_instance" "ansiblecontrollnode"{
    ami = var.ami
    instance_type = var.instance_type
    key_name = "EC2"
    vpc_security_group_ids = [aws_security_group.mylab-sec_group.id]
    subnet_id = aws_subnet.mylab-subnet1.id 
    associate_public_ip_address = true
    user_data = file("./installansible.sh")
    tags = {
      Name = "ansible-controller-node" 
    }
}

resource "aws_instance" "ansiblecmanagednode1"{
    ami = var.ami
    instance_type = var.instance_type
    key_name = "EC2"
    vpc_security_group_ids = [aws_security_group.mylab-sec_group.id]
    subnet_id = aws_subnet.mylab-subnet1.id 
    associate_public_ip_address = true
    user_data = file("./ansiblemanagednode.sh")
    tags = {
      Name = "ansiblemn-apachetomact" 
    }
}

resource "aws_instance" "dockerhost"{
    ami = var.ami
    instance_type = var.instance_type
    key_name = "EC2"
    vpc_security_group_ids = [aws_security_group.mylab-sec_group.id]
    subnet_id = aws_subnet.mylab-subnet1.id 
    associate_public_ip_address = true
    user_data = file("./Docker.sh")
    tags = {
      Name = "Docker-host" 
    }
}


resource "aws_instance" "nexus"{
    ami = var.ami
    instance_type = var.instance_type
    key_name = "EC2"
    vpc_security_group_ids = [aws_security_group.mylab-sec_group.id]
    subnet_id = aws_subnet.mylab-subnet1.id 
    associate_public_ip_address = true
    user_data = file("./installnexus.sh")
    tags = {
      Name = "Nexus-server" 
    }
}
