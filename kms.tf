module "s3_kms_key" {
  count = var.create_s3_kms_key ? 1 : 0
  source = "github.com/Coalfire-CF/ACE-AWS-KMS?ref=draft"

  key_policy            = data.aws_iam_policy_document.s3_key.json
  kms_key_resource_type = "s3"
  resource_prefix       = var.resource_prefix
}

data "aws_iam_policy_document" "s3_key" {

  dynamic "statement" {
    for_each = var.application_account_numbers
    content {
      effect = "Allow"
      actions = [
        "kms:*"]
      resources = [
        "*"]
      principals {
        identifiers = [
          "arn:${local.gov}:iam::${statement.value}:root"]
        type = "AWS"
      }
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:*"]
    resources = [
      "*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:${local.gov}:iam::${var.account_number}:root"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = [
      "*"]

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = [
      "*"]

    principals {
      type = "Service"
      identifiers = [
        "logs.${var.default_aws_region}.amazonaws.com"]
    }
  }

  statement {
    sid = "Enable CloudTrail Encrypt Permissions"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey*"]
    resources = [
      "*"]
    condition {
      test = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:${local.gov}:cloudtrail:*:${var.account_number}:trail/*"]
    }
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.application_account_numbers
    content {
      effect = "Allow"
      actions = [
        "kms:GenerateDataKey*"]
      resources = [
        "*"]
      condition {
        test = "StringLike"
        variable = "kms:EncryptionContext:aws:cloudtrail:arn"
        values = [
          "arn:${local.gov}:cloudtrail:*:${statement.value}:trail/*"]
      }
      principals {
        type = "Service"
        identifiers = [
          "cloudtrail.amazonaws.com"]
      }
    }
  }
}


module "dynamo_kms_key" {
  count = var.create_dynamo_kms_key ? 1 : 0
  source = "github.com/Coalfire-CF/ACE-AWS-KMS?ref=draft"

  key_policy            = ""
  kms_key_resource_type = "dyanmo"
  resource_prefix       = var.resource_prefix
}


module "ebs_kms_key" {
  count = var.create_ebs_kms_key ? 1 : 0

  source = "github.com/Coalfire-CF/ACE-AWS-KMS?ref=draft"

  key_policy            = ""
  kms_key_resource_type = "ebs"
  resource_prefix       = var.resource_prefix
}

data "aws_iam_policy_document" "ebs_key" {

  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:${local.partition}:iam::${var.account_number}:root"
      ]
    }
  }
  dynamic "statement" {
    for_each = var.application_account_numbers
    content {
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"]
      resources = [
        "*"]
      principals {
        type = "AWS"
        identifiers = [
          "arn:${local.partition}:iam::${statement.value}:root"]
      }
    }
  }
      dynamic "statement" {
        for_each = var.application_account_numbers
        content {
          effect = "Allow"
          actions = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey",
            "kms:CreateGrant",
            "kms:ListGrants"
          ]
          resources = [
            "*"]
          principals {
            type = "AWS"
            identifiers = [
              statement.value]
          }
          condition {
            test = "ArnEquals"
            values = ["aws:SourceArn"]
            variable = "arn:${local.partition}:iam::${statement.value}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
          }
        }
    }
}

module "sm_kms_key" {
  count = var.create_sm_kms_key ? 1 : 0
  source = "github.com/Coalfire-CF/ACE-AWS-KMS?ref=draft"

  key_policy            = data.aws_iam_policy_document.secrets_manager_key.json
  kms_key_resource_type = "sm"
  resource_prefix       = var.resource_prefix
}

data "aws_iam_policy_document" "secrets_manager_key" {
  dynamic "statement" {
    for_each = var.application_account_numbers
    content {
      effect = "Allow"
      actions = [
        "kms:*"]
      resources = [
        "*"]
      principals {
        identifiers = [
          "arn:${local.gov}:iam::${statement.value}:root"]
        type = "AWS"
      }
    }
  }

  statement {
    sid = "Enable MGMT IAM User Permissions"
    effect = "Allow"
    actions = ["kms:*"]
    principals {
      identifiers = ["arn:${local.gov}:iam::${var.account_number}:root"]
      type = "AWS"
    }
    resources = ["*"]
  }
}


module "backup_kms_key" {
  count = var.create_backup_kms_key ? 1 : 0
  source = "github.com/Coalfire-CF/ACE-AWS-KMS?ref=draft"

  key_policy            = data.aws_iam_policy_document.s3_key.json
  kms_key_resource_type = "backup"
  resource_prefix       = var.resource_prefix
}

module "lambda_kms_key" {
  count = var.create_lambda_kms_key ? 1 : 0
  source = "github.com/Coalfire-CF/ACE-AWS-KMS?ref=draft"

  key_policy            = ""
  kms_key_resource_type = "lambda"
  resource_prefix       = var.resource_prefix
}

module "rds_kms_key" {
  count = var.create_rds_kms_key ? 1 : 0
  source = "github.com/Coalfire-CF/ACE-AWS-KMS?ref=draft"

  key_policy            = ""
  kms_key_resource_type = "rds"
  resource_prefix       = var.resource_prefix
}


module "additional_kms_keys" {
  source = "github.com/Coalfire-CF/ACE-AWS-KMS?ref=draft"
  for_each = var.kms_keys

  key_policy            = var.kms_keys.value["policy"]
  kms_key_resource_type = var.kms_keys.value["name"]
  resource_prefix       = var.resource_prefix
}
