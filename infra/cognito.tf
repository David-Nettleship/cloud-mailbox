resource "aws_cognito_user_pool" "mailbox_users" {
  name = "cloud-mailbox-users"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }
}

resource "aws_cognito_user_pool_client" "mailbox_client" {
  name         = "cloud-mailbox-client"
  user_pool_id = aws_cognito_user_pool.mailbox_users.id
  generate_secret = false

  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = ["http://localhost:8000/", aws_s3_bucket.frontend.website_endpoint]
  logout_urls   = ["http://localhost:8000/", aws_s3_bucket.frontend.website_endpoint]
  supported_identity_providers = ["COGNITO"]
}
