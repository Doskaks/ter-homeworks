locals {
  # Общие параметры для имен ВМ
  env     = "develop"
  project = "platform"
  
  # Имена ВМ с использованием интерполяции
  web_vm_name = "${local.env}-${local.project}-web"
  db_vm_name  = "${local.env}-${local.project}-db"
}