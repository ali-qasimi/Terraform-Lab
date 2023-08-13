data "aws_availability_zones" "available" {
    state = "available"
} 

locals {
    availability_zones = data.aws_availability_zones.available.names
}

resource "aws_vpc" "eks_vpc" {
    cidr_block = "10.1.0.0/16"

    tags = {
        Name        = "eks_vpc"
        Environment = "development"
    }
} 


//subnets

resource "aws_subnet" "control_plane_subnets" {
    count               = length(local.availability_zones)
    vpc_id              = aws_vpc.eks_vpc.id
    cidr_block          = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 16, count.index+1)
    availability_zone   = local.availability_zones[count.index]
}

resource "aws_subnet" "application_subnets" {
    count               = length(local.availability_zones)
    vpc_id              = aws_vpc.eks_vpc.id
    cidr_block          = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 16, count.index+11)
    availability_zone   = local.availability_zones[count.index]
}

//security groups

resource "aws_security_group" "http_80_inbound" {
    name        = "http_80_inbound"
    description = "allows inbound http traffic"
    vpc_id      = aws_vpc.eks_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "https_443_inbound" {
    name        = "https_443_inbound"
    description = "allows inbound https traffic"
    vpc_id      = aws_vpc.eks_vpc.id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}