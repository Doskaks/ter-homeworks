###cloud vars

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
  description = "VPC network&subnet name"
}

# SSH vars
variable "vms_ssh_root_key" {
  type        = string
  default     = "vms_ssh_root_key"
  description = "ssh-keygen -t ed25519"
  sensitive   = true
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 4
      disk_volume = 20
    },
    {
      vm_name     = "replica"
      cpu         = 4
      ram         = 8
      disk_volume = 30
    }
  ]
}

variable "hostname" {
  type        = string
  description = "Hostname for VM (will be used in FQDN)"
  default     = "" # Пустое значение = автоматическая генерация
}