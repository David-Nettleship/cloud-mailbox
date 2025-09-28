output "user_pool_domain" {
  value = aws_cognito_user_pool_domain.mailbox_domain.domain
}

output "region" {
  value = var.region
}

output "client_id" {
  value = aws_cognito_user_pool_client.mailbox_client.id
}

output "redirect_uri" {
  value = aws_s3_bucket.frontend.website_endpoint
}

output "s3_website_url" {
  value = aws_s3_bucket.frontend.website_endpoint
}
