data "aws_default_vpc" "default" {}

output "default_vpc_id" {
  value = data.aws_default_vpc.default.id
}

data "aws_subnets" "by_az" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]
  }
}

output "subnets_by_az" {
  value = {
    for subnet in data.aws_subnets.by_az.subnets :
    subnet.availability_zone => subnet.id
  }
}

resource "aws_security_group" "sg" {
  name        = "SG-${var.projectName}"
  vpc_id      = data.aws_default_vpc.default.id

  ingress {
    description = "All"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [values(output.subnets_by_az)[data.aws_subnet.example.availability_zone]]
  }

  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnet" "example" {
  id = tolist(data.aws_subnets.by_az.ids)[0]
}