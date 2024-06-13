### General ###
variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "default_aws_region" {
  description = "The default AWS region to create resources in"
  type        = string
}

variable "application_account_numbers" {
  description = "AWS account numbers for all application accounts that might need shared access to resources like KMS keys"
  type        = list(string)
}

variable "account_number" {
  description = "The AWS account number resources are being deployed into"
  type        = string
}

variable "resource_prefix" {
  description = "The prefix for resources"
  type        = string
}

variable "is_organization" {
  description = "Whether or not to enable certain settings for AWS Organization"
  type        = bool
  default     = true
}

variable "organization_id" {
  description = "AWS Organization ID"
  type        = string
  default     = null
}

### CloudTrail ###
variable "create_cloudtrail" {
  description = "Whether or not to create cloudtrail resources"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain Cloudwatch logs"
  type        = number
  default     = 30
}

### KMS ###
variable "additional_kms_keys" {
  description = "a list of maps of any additional KMS keys that need to be created"
  type        = list(map(string))
  default     = []
}

variable "create_s3_kms_key" {
  description = "create KMS key for S3"
  type        = bool
  default     = true
}

variable "create_ebs_kms_key" {
  description = "create KMS key for ebs"
  type        = bool
  default     = true
}

variable "create_sns_kms_key" {
  description = "create KMS key for SNS"
  type        = bool
  default     = true
}

variable "create_sm_kms_key" {
  description = "create KMS key for secrets manager"
  type        = bool
  default     = true
}

variable "create_dynamo_kms_key" {
  description = "create KMS key for dynamodb"
  type        = bool
  default     = true
}

variable "create_lambda_kms_key" {
  description = "create KMS key for lambda"
  type        = bool
  default     = true
}

variable "create_rds_kms_key" {
  description = "create KMS key for rds"
  type        = bool
  default     = true
}

variable "create_backup_kms_key" {
  description = "create KMS key for AWS Backups"
  type        = bool
  default     = true
}

variable "create_cloudwatch_kms_key" {
  description = "create KMS key for AWS Cloudwatch"
  type        = bool
  default     = true
}

### S3 ###
# Note: In cases where there is a centralized logging account, it wouldn't make sense to have a bucket in every account
# this is why some defaults are false while others are true where it might be sensible for each account to have its own bucket.
variable "create_s3_accesslogs_bucket" {
  description = "Create S3 Access Logs Bucket"
  type        = bool
  default     = false
}

variable "create_s3_backups_bucket" {
  description = "Create S3 Backups Bucket"
  type        = bool
  default     = true
}

variable "create_s3_elb_accesslogs_bucket" {
  description = "Create S3 ELB Access Logs Bucket"
  type        = bool
  default     = false
}

variable "create_s3_fedrampdoc_bucket" {
  description = "Create S3 FedRAMP Documents Bucket"
  type        = bool
  default     = true
}

variable "create_s3_installs_bucket" {
  description = "Create S3 Installs Bucket"
  type        = bool
  default     = true
}

variable "s3_accesslogs_bucket_id" {
  description = "If not creating S3 access logs bucket in this module, user should provide a bucket ID for an existing S3 Access Logs bucket"
  type        = string
  default     = null
}

### Misc ###
# Note: To my knowledge, it's not a common configuration to have Terraform state across multiple accounts, so this will default to false
variable "create_security_core" {
  description = "Whether or not to create Security Core resources"
  type        = bool
  default     = false
}

# In normal usage only one account builds/holds the AMIs while it is shared to other account IDs (provided as variables to Packer)
# This is to prevent excessive numbers of AMIs in each account.
variable "create_packer_iam" {
  description = "Whether or not to create Packer IAM resources"
  type        = bool
  default     = false
}
