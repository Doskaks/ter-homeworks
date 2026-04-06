locals {
  db_vms = { for vm in var.each_vm : vm.vm_name => vm }
}

resource "yandex_compute_instance" "database" {
  for_each = local.db_vms

  name        = each.value.vm_name
  hostname    = each.value.vm_name # Добавьте эту строку для FQDN
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  allow_stopping_for_update = true

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }

  depends_on = [yandex_compute_instance.web]
}