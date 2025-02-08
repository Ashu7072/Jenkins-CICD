provider "aws" {
  region = "us-east-1"  # Change this to your preferred AWS region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "MySubnet"
  }
}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
  }
}

resource "aws_instance" "foo" {
  ami             = "ami-05fa00d4c63e32376"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]  # Fixed reference

  depends_on = [aws_subnet.my_subnet]

  tags = {
    Name = "MyEC2Instance"
  }
}
