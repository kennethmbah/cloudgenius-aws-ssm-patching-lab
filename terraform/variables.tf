variable "aws_region" {
  description = "AWS region used for the lab."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional local AWS CLI profile. Leave empty when using environment credentials or an assumed role."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project name used in resource names and tags."
  type        = string
  default     = "cloudgenius-aws-ssm-patching-lab"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "lab"
}

variable "instance_type" {
  description = "EC2 instance type for the managed node."
  type        = string
  default     = "t3.micro"
}

variable "patch_group" {
  description = "Tag value used to associate managed nodes with the patch baseline."
  type        = string
  default     = "linux-lab"
}

variable "maintenance_schedule" {
  description = "Systems Manager cron expression for the maintenance window. Default: Sunday at 03:00 UTC."
  type        = string
  default     = "cron(0 3 ? * SUN *)"
}

variable "install_patches" {
  description = "When true, the maintenance task installs approved patches. When false, it scans only."
  type        = bool
  default     = false
}
