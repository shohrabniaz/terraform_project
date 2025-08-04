resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "/%&" 
}

resource "aws_secretsmanager_secret" "rds_secrets" {
  name = "RDSPostgresql-${random_id.secret_suffix.hex}"
}

resource "aws_secretsmanager_secret_version" "rds_secrets_version" {
  secret_id = aws_secretsmanager_secret.rds_secrets.id
  secret_string = jsonencode({
    username = "postgres_db"
    password = random_password.rds_password.result
  })

  #version_stages = ["AWSCURRENT"]
}

data "aws_secretsmanager_secret" "rds_secrets_data" {
  arn = aws_secretsmanager_secret.rds_secrets.arn
}

data "aws_secretsmanager_secret_version" "rds_creds" {
  secret_id = data.aws_secretsmanager_secret.rds_secrets_data.arn
}

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_creds.secret_string)
}

resource "aws_db_instance" "postgres_db" {
  depends_on = [aws_db_subnet_group.rds_subnet_group]

  identifier                 = "soley-postgres-db"
  engine                     = "postgres"
  engine_version             = "14.7"
  instance_class             = "db.t3.micro"
  db_name                    = "mydb"
  username                   = local.rds_credentials["username"]
  password                   = local.rds_credentials["password"]
  allocated_storage          = 20
  storage_type               = "gp3"
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  parameter_group_name       = aws_db_parameter_group.postgres_db_parameter_group.name
  skip_final_snapshot        = true
  publicly_accessible        = false
  multi_az                   = false
  auto_minor_version_upgrade = true
  backup_retention_period    = 7
  maintenance_window         = "Sat:00:00-Sat:03:00"
  backup_window              = "03:00-06:00"

  tags = {
    Name = "Postgres DB"
  }
}

output "db_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

/*
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "/%&"
}

resource "aws_secretsmanager_secret" "rds_secrets" {
  name = "rds!db-24e22468-a148-446a-9846-c0eca5145cd6"
}

resource "aws_secretsmanager_secret_version" "rds_secrets_version" {
  secret_id = aws_secretsmanager_secret.rds_secrets.id
  secret_string = jsonencode({
    username = "postgres_db"
    password = random_password.rds_password.result
  })

  #version_stages = ["AWSCURRENT"]
}

data "aws_secretsmanager_secret" "rds_secrets_data" {
  arn = aws_secretsmanager_secret.rds_secrets.arn
}

data "aws_secretsmanager_secret_version" "rds_creds" {
  secret_id = data.aws_secretsmanager_secret.rds_secrets_data.arn
}

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_creds.secret_string)
}

resource "aws_db_instance" "postgres_db" {
  depends_on = [aws_db_subnet_group.rds_subnet_group]

  identifier                 = "soley-postgres-db"
  engine                     = "postgres"
  engine_version             = "14.7"
  instance_class             = "db.t3.micro"
  db_name                    = "mydb"
  username                   = local.rds_credentials["username"]
  password                   = local.rds_credentials["password"]
  allocated_storage          = 20
  storage_type               = "gp3"
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  parameter_group_name       = aws_db_parameter_group.postgres_db_parameter_group.name
  skip_final_snapshot        = true
  publicly_accessible        = false
  multi_az                   = false
  auto_minor_version_upgrade = true
  backup_retention_period    = 7
  maintenance_window         = "Sat:00:00-Sat:03:00"
  backup_window              = "03:00-06:00"

  tags = {
    Name = "Postgres DB"
  }
}

output "db_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}
*/