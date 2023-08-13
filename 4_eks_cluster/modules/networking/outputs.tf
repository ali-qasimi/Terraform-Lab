output "vpc" {
    value = {
        vpc_id = aws_vpc.application_vpc.id
        private_subnets = [for subnet in aws_subnet.all_private_subnets: subnet.id]
        public_subnets = [for subnet in aws_subnet.all_public_subnets: subnet.id]
    }
}

output "sg" {
    value = {
        http_80_inbound      = aws_security_group.http_80_inbound.id
        https_443_inbound    = aws_security_group.https_443_inbound.id

    }
}








