resource "aws_vpc" "eks" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${local.dynamic_cluster_name}-vpc"
  })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = "${var.region}${count.index % 2 == 0 ? "a" : "b"}"
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name                     = "${local.dynamic_cluster_name}-public-${count.index}"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.eks.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = "${var.region}${count.index % 2 == 0 ? "a" : "b"}"

  tags = merge(var.tags, {
    Name                              = "${local.dynamic_cluster_name}-private-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks.id

  tags = merge(var.tags, {
    Name = "${local.dynamic_cluster_name}-igw"
  })
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${local.dynamic_cluster_name}-nat-eip"
  })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "${local.dynamic_cluster_name}-nat"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${local.dynamic_cluster_name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(var.tags, {
    Name = "${local.dynamic_cluster_name}-private-rt"
  })
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}