module "security-core" {
  count = var.create_security_core ? 1 : 0

  source = "github.com/CiscoOpsStack/terraform-aws-securitycore-ops_stack-module?ref=main"

  application_account_numbers = var.application_account_numbers
  aws_region                  = var.aws_region
  resource_prefix             = var.resource_prefix

  # KMS Keys
  dynamo_kms_key_arn = module.dynamo_kms_key[0].kms_key_arn
  s3_kms_key_arn     = module.s3_kms_key[0].kms_key_arn

  vpc_id = var.vpc_id
  create_base_sgs = var.create_base_sgs

  lin_ingress_rules = var.lin_ingress_rules
  lin_egress_rules  = var.lin_egress_rules
  win_ingress_rules = var.win_ingress_rules
  win_egress_rules  = var.win_egress_rules

}
