# Security Policy

## Purpose

This repository is an educational AWS and Terraform project. Security remains a core design requirement even in a lab environment.

## Do Not Commit Sensitive Information

Never commit:

- AWS access keys or secret keys
- Session tokens
- Passwords
- Private SSH keys
- Terraform state files
- Real `terraform.tfvars` files
- Account IDs, private IP addresses, or internal hostnames in screenshots
- Customer, employer, or training-environment data

If a secret is committed, remove it from Git history and rotate or revoke it immediately. Deleting only the visible file is not sufficient because the value may remain in earlier commits.

## Recommended Controls

- Use temporary credentials, IAM Identity Center, or role assumption.
- Enable MFA for human identities.
- Follow least privilege.
- Encrypt EBS volumes, logs, S3 objects, and Terraform remote state.
- Use Session Manager instead of exposing SSH when possible.
- Review Terraform plans before applying them.
- Run security scans such as Checkov, Trivy, or tfsec in CI.
- Sanitize screenshots before publishing.

## Reporting a Security Concern

Do not open a public issue containing credentials, account information, or exploit details. Contact the repository owner privately through an appropriate verified channel.

## Educational Disclaimer

The Terraform configuration is a learning baseline. Organizations must adapt it to their own security, networking, compliance, logging, backup, and change-management requirements before production use.
