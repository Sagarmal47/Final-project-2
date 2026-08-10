resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc_var
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Test"
  }
}

# 1. Internet Gateway for outbound network access
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

# 2. Public Subnet with auto-assign public IP enabled
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.aws_subnet_var
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_tag_name"
  }
}

# 3. Route Table routing outbound traffic (0.0.0.0/0) to IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# 4. Associate Subnet with Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# 5. EC2 Instance
resource "aws_instance" "main" {
  instance_type        = "t3.medium"
  ami                  = "ami-01a00762f46d584a1"
  subnet_id            = aws_subnet.public.id
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.id

  tags = {
    Name = "react_ec2_nginx"
  }
}

# 6. IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# 7. Attach Managed SSM Policy
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 8. Instance Profile
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2_ssm_profile"
  role = aws_iam_role.ssm_role.name
}

# 9. Outputs
output "instance_id" {
  value = aws_instance.main.id
}
