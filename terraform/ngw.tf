resource "aws_eip" "ngw" {
    count = length(aws_subnet.public)
    domain = "vpc"

    tags = {
        Name = "${var.infra_environment}-eip-ngw-${count.index}"
    }
}

resource "aws_nat_gateway" "ngw" {
    count = length(aws_subnet.public)
    allocation_id = aws_eip.ngw[count.index].id
    subnet_id = aws_subnet.public[count.index].id

    tags = {
        Name = "${var.infra_environment}-ngw-${count.index}"
    }
}

resource "aws_route_table" "private" {
    count = length(aws_subnet.private)
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw[count.index].id
    }

    tags = {
        Name = "${var.infra_environment}-rt-private-${count.index}"
    }
}

resource "aws_route_table_association" "private" {
    count = length(aws_subnet.private)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}