#updatePM
resource "aws_db_parameter_group" "postgres_db_parameter_group" {
  name   = "soley-postgres-db-parameter-group"
  family = "postgres14"

  parameter {
    name  = "log_statement"
    value = "all"
  }

  tags = {
    Name = "Soley Postgres DB Parameter Group"
  }
}
