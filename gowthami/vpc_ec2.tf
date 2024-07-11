resource "aws_vpc" "my_vpc" {
  cidr_block = "172.31.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "172.31.1.0/24"
  availability_zone       = "us-east-1a"  # Specify your desired AZ
}

resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  // Define inbound and outbound rules as needed
  // For example, allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0b72821e2f351e396"  # Specify your desired AMI
  instance_type = "t3.micro"      # Specify your desired instance type
  subnet_id     = aws_subnet.my_subnet.id
  associate_public_ip_address = true  # Ensure this is set to true
  security_groups = [aws_security_group.my_security_group.id]
  key_name = "my-key"

  tags = {
    Name = "test-Instance-terraform"
    Application = "to-be-deleted"
    Restart = "WORKDAY"
   }
	ebs_block_device { 
			device_name = "/dev/sda1"
		    volume_size = "30"
		    volume_type = "io1"
		    iops = "200"
		    delete_on_termination = true
		    encrypted = true
	}
}



