# Cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

# SSH vars
variable "vms_ssh_root_key" {
  type        = string
  default     = "vms_ssh_root_key"
  description = "ssh-keygen -t ed25519"
  sensitive   = true
}

# VM web vars (устаревшие, закомментированы)
# variable "vm_web_name" {
#   type        = string
#   default     = "netology-develop-platform-web"
# }

# variable "vm_web_image_family" {
#   type        = string
#   default     = "ubuntu-2004-lts"
# }

# VM db vars (устаревшие, закомментированы)
# variable "vm_db_name" {
#   type        = string
#   default     = "netology-develop-platform-db"
#   description = "DB VM name"
# }

# variable "vm_db_image_family" {
#   type        = string
#   default     = "ubuntu-2004-lts"
#   description = "Image family for DB VM"
# }

# variable "vm_db_zone" {
#   type        = string
#   default     = "ru-central1-b"
#   description = "Availability zone for DB VM"
# }

# variable "vm_db_cores" {
#   type        = number
#   default     = 2
#   description = "Number of CPU cores for DB VM"
# }

# variable "vm_db_memory" {
#   type        = number
#   default     = 2
#   description = "Memory in GB for DB VM"
# }

# variable "vm_db_core_fraction" {
#   type        = number
#   default     = 20
#   description = "Core fraction for DB VM"
# }

# Новая map-переменная для ресурсов ВМ
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
    image_family  = string
    zone          = string
  }))
  description = "Resource configuration for VMs"
  default = {
    web = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 5
      hdd_type      = "network-hdd"
      image_family  = "ubuntu-2004-lts"
      zone          = "ru-central1-a"
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 5
      hdd_type      = "network-hdd"
      image_family  = "ubuntu-2004-lts"
      zone          = "ru-central1-b"
    }
  }
}

# Новая map-переменная для metadata (без ssh-keys в default)
variable "vm_metadata" {
  type = map(string)
  description = "Common metadata for all VMs"
  default = {
    serial-port-enable = "1"
    # ssh-keys будет переопределен в personal.auto.tfvars или через переменную
  }
}