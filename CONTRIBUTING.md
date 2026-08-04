# Contributing

Thank you for your interest in improving this educational AWS Systems Manager patch-management project.

## Contribution Workflow

1. Fork the repository.
2. Create a focused branch such as `docs/improve-troubleshooting`.
3. Make one logical change at a time.
4. Format and validate Terraform before committing.
5. Remove credentials, account details, and sensitive screenshots.
6. Open a pull request explaining the problem, the change, and how it was tested.

## Terraform Quality Checks

Run the following from the `terraform/` directory:

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

Optional security and quality checks:

```bash
tflint
checkov -d .
trivy config .
```

## Documentation Standards

- Write for beginners without removing technical accuracy.
- Explain acronyms the first time they appear.
- Connect technical controls to business value.
- Add a short “What I Learned” section to major learning topics.
- Redact account IDs, IP addresses, resource identifiers, and personal information.

## Pull Request Expectations

A pull request should include:

- A clear title.
- A concise description.
- Validation steps.
- Security or cost considerations.
- Updated documentation when behavior changes.

## Code of Conduct

Be respectful, constructive, and supportive of learners at all experience levels.
