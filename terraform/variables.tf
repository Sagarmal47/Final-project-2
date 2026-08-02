variables "aws_subnet" {
    cidr_block_subnet = "10.0.0.0/28"
    subnet_tag_name = "aws_public_subnet"
}

variables "aws_vpc" {
     cidr_vpc_block = "10.0.0.0/28"
       cidr_tag_name = "aws_cidr_test"


}
