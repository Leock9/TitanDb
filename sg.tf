variable "create_security_group" {
  type        = bool
  description = "Whether to create a new security group"
  default     = true
}

resource "aws_security_group" "sg" {
  count = var.create_security_group == true ? 1 : 0

  name        = "SG-${var.projectName}"
  vpc_id      = var.vpcId

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
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_security_group" "sg" {
  count = var.create_security_group == false ? 1 : 0

  name        = "SG-${var.projectName}"
  vpc_id      = var.vpcId
}

output "security_group_id" {
  value = var.create_security_group == true ? aws_security_group.sg[0].id : data.aws_security_group.sg[0].id
}