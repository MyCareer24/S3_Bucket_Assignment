#GIVE ME URL OF MY WEBSITE AFTER DEPLOYMENT
output "website_url" {
description = "My website ~URL"
value = aws_s3_bucket_website_configuration.project_web-config.website_endpoint
}