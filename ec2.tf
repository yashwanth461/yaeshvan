resource "aws_instance" "my-web" {
  ami="ami-078264b8ba71bc45e"
  instance_type = "t2.micro"
  tags = {
    Name="terraforms"
  }
  key_name = "jenkins"
 
  
}