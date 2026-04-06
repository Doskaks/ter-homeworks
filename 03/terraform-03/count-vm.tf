resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  hostname    = "web-${count.index + 1}" # Добавьте эту строку для FQDN
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
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
}