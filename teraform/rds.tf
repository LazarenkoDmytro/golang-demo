resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t4g.micro"
  db_name              = "demo_db"
  username             = "dbadmin"
  password             = "password"
  parameter_group_name = "default.postgres13"
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.main.id
}

resource "aws_db_subnet_group" "main" {
  name = "main"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]

  tags = {
    Name = "main"
  }
}