resource "aws_vpc" "main" {
    cidr_block = "10.1.0.0/16"

    tags = {
        Name        = "main"
        Environment = "homelab"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = "10.1.1.0/24"
    availability_zone   = var.region
}

resource "aws_security_group" "web_instance_sg" {
    name        = "web-server-security-group"
    description = "Allowing https requests only"
    vpc_id      = aws_vpc.main.id

    tags = {
        Name = "web-server-security-group"
    }
    
    ingress {
        description = "Allow inbound https traffic"
        cidr_blocks = [aws_subnet.private_subnet.cidr_block]
        from_port   = 443
        protocol    = "tcp"
        to_port     = 443
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }  
}

resource "aws_launch_template" "web_launch_template" {
    name = "ec2-launch-template"
    image_id = "ami-6ff07e0fbb006c28b"
    instance_type = "t3.medium"
    vpc_security_group_ids = [aws_security_group.web_instance_sg.id]
}

resource "aws_autoscaling_group" "asg" {
    vpc_zone_identifier = [aws_subnet.private_subnet.id]
    desired_capacity = 2
    max_size = 3
    min_size = 1

    launch_template {
        id = aws_launch_template.web_launch_template.id
        version = "$Latest"
    }
}