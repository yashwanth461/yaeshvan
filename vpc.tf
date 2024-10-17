# Create the VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "my-vpc"
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "my-gw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-gw"
  }
}

# Create the private subnet with a valid CIDR block
resource "aws_subnet" "myprivatesubnet" {
  cidr_block = "10.0.0.16/28"  # Change to a non-overlapping CIDR block
  vpc_id    = aws_vpc.my-vpc.id
  tags = {
    Name = "private"
  }
}

# Create the public subnet
resource "aws_subnet" "mypublicsubnet" {
  cidr_block = "10.0.0.0/28"  # Public subnet CIDR
  vpc_id    = aws_vpc.my-vpc.id
  tags = {
    Name = "public"
  }
}

# Create the private route table
resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "private route"
  }
}

# Create the public route table
resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "public-route"
  }
}

# Associate the private subnet with the private route table
resource "aws_route_table_association" "privateasso" {
  subnet_id      = aws_subnet.myprivatesubnet.id  # Correct reference
  route_table_id = aws_route_table.privateroute.id  # Correct reference
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "publicasso" {
  subnet_id      = aws_subnet.mypublicsubnet.id  # Correct reference
  route_table_id = aws_route_table.publicroute.id  # Correct reference
}

# Create a route in the public route table to allow internet access
resource "aws_route" "route" {
  route_table_id         = aws_route_table.publicroute.id  # Correct reference
  destination_cidr_block = "0.0.0.0/0"  # All outbound traffic
  gateway_id             = aws_internet_gateway.my-gw.id  # Correct reference
}
