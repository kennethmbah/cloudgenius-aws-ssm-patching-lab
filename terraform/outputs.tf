output "managed_instance_id" {
  description = "EC2 instance ID of the Systems Manager managed node."
  value       = aws_instance.managed_node.id
}

output "managed_instance_name" {
  description = "Name tag assigned to the managed node."
  value       = aws_instance.managed_node.tags["Name"]
}

output "iam_role_name" {
  description = "IAM role used by the EC2 instance."
  value       = aws_iam_role.ssm_instance.name
}

output "patch_baseline_id" {
  description = "Custom Systems Manager patch baseline ID."
  value       = aws_ssm_patch_baseline.linux.id
}

output "maintenance_window_id" {
  description = "Systems Manager maintenance window ID."
  value       = aws_ssm_maintenance_window.patching.id
}

output "patch_operation" {
  description = "Scheduled patch operation. Scan is the safer lab default."
  value       = var.install_patches ? "Install" : "Scan"
}
