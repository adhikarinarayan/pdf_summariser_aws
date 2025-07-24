# vpc.tf

# This block configures the AWS provider, telling Terraform we are building infrastructure on AWS.
provider "aws" {
  region = "us-east-1" # You can choose any region that suits you.
}

# This block defines our Virtual Private Cloud (VPC).
# A VPC is a logically isolated section of the AWS Cloud where you can launch AWS resources.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" # This defines the IP address range for our entire network.

  tags = {
    Name = "main-vpc"
  }
}

# We need an Internet Gateway to allow communication between our VPC and the internet.
# Resources in public subnets can use this to get out.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# A public subnet. Resources launched here can be assigned a public IP address.
# We'll place our load balancer here later. We create two for high availability across Availability Zones.
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-b"
  }
}

# A private subnet. Resources here are not directly accessible from the internet.
# This is where our secure application servers and database will live.
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-b"
  }
}
