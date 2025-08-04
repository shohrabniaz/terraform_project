/*resource "aws_secretsmanager_secret" "fraxon_credentials" {
  name = "FraxonCredentials"
}

resource "aws_secretsmanager_secret_version" "fraxon_credentials_version" {
  secret_id     = aws_secretsmanager_secret.fraxon_credentials.id
  secret_string = jsonencode({
    username               = var.username
    password               = var.password
    subscription_key       = var.subscription_key
    tenant_id              = var.tenant_id
    client_secret          = var.client_secret
    client_id              = var.client_id
  })
}*/

resource "aws_secretsmanager_secret" "fraxon_credentials" {
  name = "dev/fraxion/access_token"
}

resource "aws_secretsmanager_secret_version" "fraxon_credentials_version" {
  secret_id     = aws_secretsmanager_secret.fraxon_credentials.id
  secret_string = jsonencode({
    username           = var.username
    password           = var.password
    subscription_key   = var.subscription_key
    tenant_id          = var.tenant_id
    client_secret      = var.client_secret
    client_id          = var.client_id
  })
}
