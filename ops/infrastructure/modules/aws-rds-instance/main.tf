resource "aws_db_instance" "main" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "12.7"
  instance_class       = "db.t2.micro"
  name                 = var.name
  username             = "mega_root"
  password             = random_password.password.result
  identifier_prefix    = lower("identifier-${var.name}")
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  publicly_accessible  = false
  skip_final_snapshot  = true
  vpc_security_group_ids = concat([aws_security_group.rds_security_group.id], var.assigned_security_groups)
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "main"
  subnet_ids = var.vpc.subnet_ids

  tags = {
    Name = "Subnet group for ${var.name}"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = false
}

resource "aws_security_group" "rds_security_group" {
  name_prefix = "rds_security_group"
  description = "Security group for RDS"
  vpc_id      = var.vpc.vpc_id

  ingress {
    description      = "Ingress for database"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
  }

  tags = {
    Name = "${var.name}-rds-sg"
  }
}

resource "aws_security_group" "connection_security_group" {
  name_prefix = "${var.name}-db-connector-"
  description = "Connector for RDS"
  vpc_id      = var.vpc.vpc_id
}
