resource "aws_vpc" "vpc_eks" {
    cidr_block = "10.4.0.0/16"

    tags = {
        Name        = "main"
        Environment = "homelab"
    }
}

resource "aws_subnet" "control_plane_subnet_a" {
    vpc_id              = aws_vpc.vpc_eks.id
    cidr_block          = "10.4.1.0/24"
    availability_zone   = var.region
}

resource "aws_subnet" "control_plane_subnet_b" {
    vpc_id              = aws_vpc.vpc_eks.id
    cidr_block          = "10.4.2.0/24"
    availability_zone   = var.region
}

resource "aws_subnet" "control_plane_subnet_c" {
    vpc_id              = aws_vpc.vpc_eks.id
    cidr_block          = "10.4.3.0/24"
    availability_zone   = var.region
}

resource "aws_subnet" "node_subnet_a" {
    vpc_id              = aws_vpc.vpc_eks.id
    cidr_block          = "10.4.1.0/24"
    availability_zone   = var.region
}

resource "aws_subnet" "node_subnet_b" {
    vpc_id              = aws_vpc.vpc_eks.id
    cidr_block          = "10.4.2.0/24"
    availability_zone   = var.region
}

resource "aws_subnet" "node_subnet_c" {
    vpc_id              = aws_vpc.vpc_eks.id
    cidr_block          = "10.4.3.0/24"
    availability_zone   = var.region
}