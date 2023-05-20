resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.tags[0]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.tags[1]
  }
}

resource "aws_subnet" "subnet" {
  count      = 2
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr[count.index]

  tags = {
    Name = var.tags[2 + count.index]
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.any
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.tags[4]
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  
 dynamic "ingress" {
  for_each = var.ingress_rules 
  content {
     from_port   = ingress.value.from_port   
     to_port     = ingress.value.to_port      
     protocol    = ingress.value.protocol
     cidr_blocks = ingress.value.cidr_blocks
  }    
}

egress {
    from_port   = var.egress_rules[0].from_port  
    to_port     = var.egress_rules[0].to_port  
    protocol    = var.egress_rules[0].protocol  
    cidr_blocks = var.egress_rules[0].cidr_blocks 
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet[0].id
  tags = {
    Name = var.tags[5]
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block        = var.any
    nat_gateway_id    = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = var.tags[6]
  }
}

resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.subnet[1].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_instance" "web" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name 
  user_data     = file("user_data.sh")

  vpc_security_group_ids = [aws_security_group.sg.id]
  
  subnet_id    = aws_subnet.subnet[count.index].id
  associate_public_ip_address = count.index == 0 ? true : false  
  depends_on = [
    aws_route_table.private_rt,
    aws_route_table.public_rt 
  ]  
  tags = {
    Name = var.tags[count.index + 7]
  }
}