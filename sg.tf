data "aws_vpc" "default" {
  default = true
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

data "aws_subnets" "by_az" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  tags = {
    Name = "*"
  }
}

output "subnet_ids_by_az" {
  value = {
    for subnet in data.aws_subnets.by_az.ids :
    data.aws_subnet.by_az[subnet].availability_zone => subnet
  }
}

resource "aws_security_group" "sg" {
  name        = "SG-${var.projectName}"
  vpc_id      = data.aws_vpc.default.id

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
    cidr_blocks = [values(output.subnet_ids_by_az)[values(keys(output.subnet_ids_by_az))[0]]]
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

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}