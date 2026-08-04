# Screenshot Evidence Guide

Add sanitized screenshots to this directory and reference them from the main README.

## Recommended Screenshots

1. `01-terraform-init.png` — successful Terraform initialization.
2. `02-terraform-plan.png` — reviewed infrastructure plan.
3. `03-managed-node.png` — EC2 instance online in Systems Manager.
4. `04-patch-baseline.png` — patch approval rules.
5. `05-maintenance-window.png` — schedule and duration.
6. `06-patch-scan.png` — completed scan command.
7. `07-compliance-dashboard.png` — patch compliance summary.
8. `08-patch-install.png` — successful installation task.

## Before Publishing

Redact or crop:

- AWS account IDs
- Public and private IP addresses
- Instance IDs when not needed
- Email addresses and usernames
- Internal DNS names
- Organization-specific naming
- Credentials, tokens, and command history containing secrets

Each screenshot should have a short caption explaining what it proves and why it matters.
