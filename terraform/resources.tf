resource "aws_vpc" "main" {
cidr_block = var.cidr_vpc_block
tags = {
    Name = var.cidr_tag_name
}
}

resource "aws_subnet" "public" {
   
vpc_id = aws_vpc.main.id
cidr_block = var.cidr_block_subnet 
tags = {
  Name = var.subnet_tag_name

}
}
 

resource "aws_instance" "main" {
   instance_type = "t3.medium"
   ami = "ami-01a00762f46d584a1"
   subnet_id = aws_subnet.public.id
   tags = {
              Name = "react_ec2_nginx"

}


}
