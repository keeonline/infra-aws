resource "aws_ecs_cluster" "applications" {
  name = "${var.infra_environment}-ecs-cluster-applications"

  tags = {
    Name = "${var.infra_environment}-ecs-cluster-applications"
  }
}

resource "aws_security_group" "app_services" {
  name = "${var.infra_environment}-sg-app-services"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.infra_environment}-sg-app-services"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_consumer" {
    count = length(aws_subnet.public)
    security_group_id = aws_security_group.app_services.id
    cidr_ipv4 = aws_subnet.public[count.index].cidr_block
    from_port = 8080
    ip_protocol = "tcp"
    to_port = 8080
  
    tags = {
        Name = "${var.infra_environment}-sg-ingress-rule-app-consumer-${count.index}"
    }
}

resource "aws_vpc_security_group_ingress_rule" "app_management" {
    count = length(aws_subnet.public)
    security_group_id = aws_security_group.app_services.id
    cidr_ipv4 = aws_subnet.public[count.index].cidr_block
    from_port = 9080
    ip_protocol = "tcp"
    to_port = 9080
  
    tags = {
        Name = "${var.infra_environment}-sg-ingress-rule-app-management-${count.index}"
    }
}

resource "aws_vpc_security_group_egress_rule" "app_services" {
    security_group_id = aws_security_group.app_services.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
  
    tags = {
        Name = "${var.infra_environment}-sg-egress-rule-app-services"
    }
}