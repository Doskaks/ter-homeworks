# VPC network
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

# Subnet for web VM
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.vms_resources["web"].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# Subnet for db VM
resource "yandex_vpc_subnet" "develop_db" {
  name           = "${var.vpc_name}-db"
  zone           = var.vms_resources["db"].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

# Data source for web VM image
data "yandex_compute_image" "ubuntu" {
  family = var.vms_resources["web"].image_family
}

# Data source for db VM image
data "yandex_compute_image" "ubuntu_db" {
  family = var.vms_resources["db"].image_family
}

# Web VM
resource "yandex_compute_instance" "platform" {
  name        = local.web_vm_name
  platform_id = "standard-v3"
  zone        = var.vms_resources["web"].zone
  
  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["web"].hdd_size
      type     = var.vms_resources["web"].hdd_type
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  # Собираем metadata: берем значения из переменной и добавляем ssh-keys
  metadata = merge(var.vm_metadata, {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  })
}

# DB VM
resource "yandex_compute_instance" "platform_db" {
  name        = local.db_vm_name
  platform_id = "standard-v3"
  zone        = var.vms_resources["db"].zone
  
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
      size     = var.vms_resources["db"].hdd_size
      type     = var.vms_resources["db"].hdd_type
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = true
  }

  # Собираем metadata: берем значения из переменной и добавляем ssh-keys
  metadata = merge(var.vm_metadata, {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  })
}