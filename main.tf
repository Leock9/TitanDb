provider "aws" {
  profile = "academy"
  region = "us-east-1" 
}

resource "aws_db_instance" "postgres_db" {
  skip_final_snapshot    = true
  allocated_storage      = 5
  identifier             = "db-burguer"
  instance_class         = "db.t4g.micro"
  engine                 = "postgres"
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  vpc_security_group_ids = [aws_security_group.sg.id]

  depends_on = [ aws_security_group.sg ]
}