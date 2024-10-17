resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name ="my-vpc"
  }
}

resource "aws_internet_gateway" "my-gw" {
    vpc_id = aws_vpc.my-vpc.id
  tags ={
    Name ="my-gw"
  }
}

resource  "aws_subnet" "myprivatesubnet"{
    cidr_block = "10.0.0.0/16"
    vpc_id = aws_vpc.my-vpc.id
    tags={
        Name="private"
    }
}

resource "aws_subnet" "mypublicsubnet" {
    cidr_block = "10.0.0.0/28"
    vpc_id = aws_vpc.my-vpc.id
    tags ={
        Name="public"
    }
}

resource "aws_route_table" "privateroute"{
    vpc_id = aws_vpc.my-vpc.id
    tags ={
        Name="private route"
    }
}

resource "aws_route_table" "publicroute"{
    vpc_id = aws_vpc.my-vpc.id
    tags = {
         Name="public-route"
    }
}

resource "aws_route_table_assosciation" "privateasso"{
    subnet_id="aws_subnet_myprivatesubnet.id"
    route_table_id=aws_route_table_privateroute.id
}

resource "aws_route_table_assosciation" "publicasso"{
    subnet_id="aws_subnet_mypublicsubnet.id"
    route_table_id=aws_route_table_publicroute.id
}

resource "aws_route" "route" {
  route_table_id = "aws_route_table_publicroute.id"
  destination_cidr_block = "0.0.0.0/0"
}

