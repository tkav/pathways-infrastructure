
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "default"

  tags = {
    Name = "${var.project_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_prefix}-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = var.public_subnet_count
  cidr_block        = "${var.public_subnet_cidr_blocks[count.index]}"
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_prefix}-public-${var.subnet_suffix[count.index]}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = var.private_subnet_count
  cidr_block        = "${var.private_subnet_cidr_blocks[count.index]}"
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_prefix}-private-${var.subnet_suffix[count.index]}"
  }
}

resource "aws_eip" "vpc_eip" {
  vpc    = true
  count  = var.public_subnet_count

  tags = {
    Name = "${var.project_prefix}-eip-${count.index}"
  }

}

resource "aws_nat_gateway" "natgw" {
  count         = var.public_subnet_count
  allocation_id = aws_eip.vpc_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.project_prefix}-nat-gw-${count.index}"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id        = aws_vpc.vpc.id
  service_name  = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_route_table" "public" {
  count         = var.public_subnet_count
  vpc_id        = aws_vpc.vpc.id

  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "${var.project_prefix}-public-${count.index}"
  }
}

resource "aws_route" "public_routes" {
  count                     = var.public_subnet_count
  route_table_id            = aws_route_table.public[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public[count.index].id

  depends_on = [aws_subnet.public_subnet, aws_route_table.public]

}

resource "aws_route_table" "private" {
  count         = var.private_subnet_count
  vpc_id        = aws_vpc.vpc.id

  depends_on = [aws_nat_gateway.natgw]

  tags = {
    Name = "${var.project_prefix}-private-${count.index}"
  }
}

resource "aws_route" "private_routes" {
  count                     = var.private_subnet_count
  route_table_id            = aws_route_table.private[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.natgw[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id

  depends_on = [aws_subnet.private_subnet, aws_route_table.private]

}

resource "aws_security_group" "weather_app_alb_sg" {
  name        = "weather-app-alb-sg"
  description = "weather-app-alb-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  tags = {
    Name = "weather-app-alb-sg"
  }
}

resource "aws_security_group" "weather_app_ecs_sg" {
  name        = "weather-app-ecs-sg"
  description = "weather-app-ecs-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "ECS"
      from_port        = 3000
      to_port          = 3000
      protocol         = "tcp"
      security_groups  = [aws_security_group.weather_app_alb_sg.id]
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self = false
    }
  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  depends_on = [aws_security_group.weather_app_alb_sg]

  tags = {
    Name = "weather-app-ecs-sg"
  }
}