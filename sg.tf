data "aws_vpc" "default" {
  default = true
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
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
    cidr_blocks = ["172.31.32.0/20", "172.31.0.0/20", "172.31.80.0/20" ]
 }
 
  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}