/*provider "random" {}

resource "random_id" "secret_suffix" {
  byte_length = 8
}

resource "aws_secretsmanager_secret" "db_config_secrets" {
  name = "DBConfigSecret-${random_id.secret_suffix.hex}"
}

resource "aws_secretsmanager_secret_version" "db_config_secrets_version" {
  depends_on = [aws_db_instance.postgres_db]

  secret_id     = aws_secretsmanager_secret.db_config_secrets.id
  secret_string = jsonencode({
    DATABASE = aws_db_instance.postgres_db.db_name
    HOST     = aws_db_instance.postgres_db.endpoint
    USER     = aws_db_instance.postgres_db.username
    PASSWORD = aws_db_instance.postgres_db.password
    PORT     = aws_db_instance.postgres_db.port
  })
}*/

resource "aws_secretsmanager_secret" "db_config_secrets" {
  name = "dev/soleyapi/db"
}

resource "aws_secretsmanager_secret_version" "db_config_secrets_version" {
  depends_on = [aws_db_instance.postgres_db]

  secret_id     = aws_secretsmanager_secret.db_config_secrets.id
  secret_string = jsonencode({
    DATABASE = aws_db_instance.postgres_db.db_name
    HOST     = aws_db_instance.postgres_db.endpoint
    USER     = aws_db_instance.postgres_db.username
    PASSWORD = aws_db_instance.postgres_db.password
    PORT     = aws_db_instance.postgres_db.port
  })
}
