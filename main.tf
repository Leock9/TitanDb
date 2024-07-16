provider "aws" {
  region = "us-east-1" 
}

resource "aws_db_instance" "postgres_db_soul" {
  skip_final_snapshot    = true
  allocated_storage      = 5
  identifier             = "pgdbSoul"
  instance_class         = "db.t4g.micro"
  engine                 = "postgres"
  db_name                = "dbSoulMenu"
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  vpc_security_group_ids = [aws_security_group.sg.id]

  depends_on = [ aws_security_group.sg ]
}

resource "aws_db_instance" "postgres_db_hermes" {
  skip_final_snapshot    = true
  allocated_storage      = 5
  identifier             = "pgdbHermes"
  instance_class         = "db.t4g.micro"
  engine                 = "postgres"
  db_name                = "dbHermesControl"
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  vpc_security_group_ids = [aws_security_group.sg.id]

  depends_on = [ aws_security_group.sg ]
}

resource "aws_dynamodb_table" "client_table" {
  name           = "Client"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  tags = {
    Name        = "ClientTable"
    Environment = "Production"
  }
}
