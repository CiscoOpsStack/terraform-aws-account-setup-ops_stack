module "s3-elb-accesslogs" {
  #checkov:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default"
  source = "github.com/Coalfire-CF/terraform-aws-s3?ref=v1.0.1"

  name                    = "${var.resource_prefix}-${var.aws_region}-elb-accesslogs"
  attach_public_policy    = false
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#enable-access-logs-troubleshooting
  # KMS keys are not supported for Classic Load Balancer logging
  enable_kms = false

  # S3 Access Logs
  logging       = true
  target_bucket = module.s3-accesslogs.id
  target_prefix = "elb-accesslogs/"

  # Bucket Policy
  bucket_policy           = true
  aws_iam_policy_document = data.aws_iam_policy_document.elb_accesslogs_bucket_policy.json
}
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html
data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "elb_accesslogs_bucket_policy" {
  statement {
    actions = ["s3:GetBucketAcl"]
    effect  = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.resource_prefix}-${var.aws_region}-elb-accesslogs"]
  }

  statement {
    actions = ["s3:PutObject"]
    effect  = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.resource_prefix}-${var.aws_region}-elb-accesslogs/*"]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }

  statement {
    actions = ["s3:PutObject"]
    effect  = "Allow"
    principals {
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_elb_service_account.main.id}:root"]
      type        = "AWS"
    }
    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${var.resource_prefix}-${var.aws_region}-elb-accesslogs/lb/AWSLogs/${var.account_number}/*",
      "arn:${data.aws_partition.current.partition}:s3:::${var.resource_prefix}-${var.aws_region}-elb-accesslogs/AWSLogs/${var.account_number}/*"
    ]
  }

  dynamic "statement" {
    for_each = var.application_account_numbers
    content {
      actions = ["s3:PutObject"]
      effect  = "Allow"
      principals {
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_elb_service_account.main.id}:root"]
        type        = "AWS"
      }
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.resource_prefix}-${var.aws_region}-elb-accesslogs/lb/AWSLogs/${statement.value}/*"]
    }
  }
}
