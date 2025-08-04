resource "aws_secretsmanager_secret" "cdd_secrets" {
  name = "dev/cdd/access"
}

resource "aws_secretsmanager_secret_version" "cdd_secrets_version" {
  secret_id     = aws_secretsmanager_secret.cdd_secrets.id
  secret_string = jsonencode({
    access_token = var.cdd_access_token
    vault        = var.cdd_vault
    project      = var.cdd_project
    url          = var.cdd_url
  })
}
