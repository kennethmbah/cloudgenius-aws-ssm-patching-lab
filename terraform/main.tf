data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_iam_role" "ssm_instance" {
  name = "${var.project_name}-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ssm_instance.name
}

resource "aws_security_group" "managed_node" {
  name        = "${var.project_name}-managed-node"
  description = "No inbound administration ports; use AWS Systems Manager"
  vpc_id      = data.aws_vpc.default.id

  egress {
    description = "Allow outbound access to AWS services and package repositories"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-managed-node"
  }
}

resource "aws_instance" "managed_node" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = sort(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.managed_node.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm.name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 10
  }

  tags = {
    Name       = "${var.project_name}-managed-node"
    PatchGroup = var.patch_group
  }

  depends_on = [aws_iam_role_policy_attachment.ssm_core]
}

resource "aws_ssm_patch_baseline" "linux" {
  name             = "${var.project_name}-linux-baseline"
  description      = "CloudGenius lab baseline for Amazon Linux security and bug-fix patches"
  operating_system = "AMAZON_LINUX_2023"

  approval_rule {
    approve_after_days = 7

    patch_filter {
      key    = "CLASSIFICATION"
      values = ["Security", "Bugfix"]
    }

    patch_filter {
      key    = "SEVERITY"
      values = ["Critical", "Important", "Medium"]
    }
  }

  approved_patches_compliance_level = "HIGH"
}

resource "aws_ssm_patch_group" "linux" {
  baseline_id = aws_ssm_patch_baseline.linux.id
  patch_group = var.patch_group
}

resource "aws_ssm_maintenance_window" "patching" {
  name                       = "${var.project_name}-maintenance-window"
  description                = "Scheduled AWS Systems Manager patch scan or installation"
  schedule                   = var.maintenance_schedule
  duration                   = 3
  cutoff                     = 1
  allow_unassociated_targets = false
}

resource "aws_ssm_maintenance_window_target" "patch_group" {
  window_id     = aws_ssm_maintenance_window.patching.id
  name          = "${var.project_name}-patch-target"
  description   = "Targets EC2 instances by PatchGroup tag"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:PatchGroup"
    values = [var.patch_group]
  }
}

resource "aws_ssm_maintenance_window_task" "patch" {
  window_id        = aws_ssm_maintenance_window.patching.id
  name             = "${var.project_name}-run-patch-baseline"
  description      = "Runs AWS-RunPatchBaseline against the managed-node patch group"
  task_arn         = "AWS-RunPatchBaseline"
  task_type        = "RUN_COMMAND"
  priority         = 1
  service_role_arn = null
  max_concurrency  = "1"
  max_errors       = "1"

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.patch_group.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = [var.install_patches ? "Install" : "Scan"]
      }

      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }
    }
  }
}
