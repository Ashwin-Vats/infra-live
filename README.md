# infra-live

This repository contains environment-specific Terraform stacks that provision AWS infrastructure foundations for Kubernetes platforms.

## Environments

- `dev/`: Development environment
- `stage/`: Staging environment
- `prod/`: Production environment

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- Access to AWS account with necessary permissions

## Quick Start

### Provision Infrastructure

1. Navigate to the desired environment directory:
   ```bash
   cd dev  # or stage/prod
   ```

2. Initialize Terraform:
   ```bash
   make init
   ```

3. Review the plan:
   ```bash
   make plan
   ```

4. Apply the changes:
   ```bash
   make apply
   ```

### Outputs

After successful apply, the following outputs are available:

- `vpc_id`: VPC ID
- `public_subnets`: List of public subnet IDs
- `private_subnets`: List of private subnet IDs
- `hosted_zone_id`: Route53 hosted zone ID
- `hosted_zone_name`: Route53 hosted zone name
- `oidc_issuer`: OIDC issuer URL for IRSA
- `s3_state_bucket`: S3 bucket for Terraform state
- `kms_arn`: KMS key ARN for encryption
- `external_dns_role_arn`: IAM role ARN for external-dns
- `cert_manager_role_arn`: IAM role ARN for cert-manager
- `cluster_autoscaler_role_arn`: IAM role ARN for cluster-autoscaler
- `argocd_repo_server_role_arn`: IAM role ARN for ArgoCD repo-server
- `node_instance_profile_arn`: Instance profile ARN for nodes

### Destroy Infrastructure

To destroy the infrastructure:

```bash
make destroy
```

**Warning**: This will destroy all resources in the environment. Ensure you have backups and understand the implications.

## Architecture

See [aws-topology-diagram.txt](aws-topology-diagram.txt) for the AWS infrastructure topology diagram.

## Modules Used

This stack uses the following modules from `../infra-modules/`:

- `s3-backend`: Remote state management with S3 and DynamoDB
- `vpc`: VPC, subnets, NAT gateways, route tables
- `iam`: IAM users, roles, and policies for kOps and IRSA
- `security_groups`: Security groups for bastion and other resources
- `kms`: KMS keys for encryption
- `bastion`: Bastion host for SSH access
- `kops-s3`: S3 bucket for kOps state
- `dns`: Route53 hosted zone
- `kops-oidc`: OIDC provider for IRSA

## Security Considerations

- Remote state is encrypted with KMS
- IAM roles use least-privilege principles
- IRSA is configured for secure service account access
- Private subnets for worker nodes
- Bastion host for secure access to private resources
