resource "aws_security_group" "alb" {
    name = "${var.infra_environment}-sg-alb"
    vpc_id = aws_vpc.main

    tags = {
        Name = "${var.infra_environment}-sg-alb"
    }
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_services" {
    security_group_id = aws_security_group.alb.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80

    tags = {
        Name = "${var.infra_environment}-sg-rule-alb-public-http-ingress"
    }    
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_services" {
    count = length(aws_subnet.private)
    security_group_id = aws_security_group.alb.id
    cidr_ipv4 = aws_subnet.private[count.index].cidr_block
    from_port = 8080
    ip_protocol = "tcp"
    to_port = 8080

    tags = {
        Name = "${var.infra_environment}-sg-rule-alb-egress-services-${count.index}"
    }    
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_management" {
    count = length(aws_subnet.private)
    security_group_id = aws_security_group.alb.id
    cidr_ipv4 = aws_subnet.private[count.index].cidr_block
    from_port = 9080
    ip_protocol = "tcp"
    to_port = 9080

    tags = {
        Name = "${var.infra_environment}-sg-rule-alb-egress-management-${count.index}"
    }    
}

resource "aws_alb" "alb" {
    name = "${var.infra_environment}-alb"
    internal = false
    load_balancer_type = "application"
    subnets = [for subnet in aws_subnet.public : subnet.id]
    security_groups = [aws_security_group.alb.id]

    tags = {
        Name = "${var.infra_environment}-alb"
    }    

}

resource "aws_lb_listener" "api_requests" {
    load_balancer_arn = aws_alb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "The service you have requested is unavailable"
        status_code = 503
      }
    }

    tags = {
        Name = "${var.infra_environment}-alb-listener-api-requests"
    }    
}