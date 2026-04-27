output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = module.dns.zone_id
}

output "hosted_zone_name" {
  description = "Route53 hosted zone name"
  value       = module.dns.zone_name
}

output "oidc_issuer" {
  description = "OIDC issuer URL"
  value       = "https://oidc.${var.cluster_name}"
}

output "s3_state_bucket" {
  description = "S3 state bucket name"
  value       = module.backend.bucket_name
}

output "kms_arn" {
  description = "KMS key ARN"
  value       = module.kms.kms_key_arn
}

output "external_dns_role_arn" {
  description = "External DNS IAM role ARN"
  value       = module.iam.external_dns_role_arn
}

output "cert_manager_role_arn" {
  description = "Cert Manager IAM role ARN"
  value       = module.iam.cert_manager_role_arn
}

output "cluster_autoscaler_role_arn" {
  description = "Cluster Autoscaler IAM role ARN"
  value       = module.iam.cluster_autoscaler_role_arn
}

output "argocd_repo_server_role_arn" {
  description = "ArgoCD Repo Server IAM role ARN"
  value       = module.iam.argocd_repo_server_role_arn
}

output "node_instance_profile_arn" {
  description = "Node instance profile ARN"
  value       = module.iam.node_instance_profile_arn
}