module "backups" {
    source = "github.com/Coalfire-CF/ACE-AWS-Backup?ref=v0.0.1"



    account_number             = var.account_number
    aws_region                 = var.aws_region
    backup_kms_arn             = module.backup_kms_key.kms_key_arn
    backup_plan_name           = var.aws_backup_plan_name
    backup_rule_name           = var.backup_rule_name
    backup_selection_tag_value = var.backup_selection_tag_value
    backup_vault_name          = var.backup_vault_name
    delete_after               = var.delete_after
    is_gov                     = var.is_gov
    partition                  = var.partition
    resource_prefix            = var.resource_prefix
}