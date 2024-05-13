variable "projectName" {
  default = "burguerspace"
}

variable "DB_USERNAME" {}
variable "DB_PASSWORD" {}

variable "vpc_cidr_block" {
  default = "172.31.0.0/16"
}