# 1. Создание 3 одинаковых виртуальных дисков размером 1 Гб с помощью count
resource "yandex_compute_disk" "storage_disk" {
  count = 3

  name     = "storage-disk-${count.index + 1}"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = 1  # 1 Гб
}

# 2. Создание одиночной ВМ "storage" с подключением дополнительных дисков через dynamic block
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  hostname    = "storage"
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

  # Dynamic блок для подключения всех созданных дисков
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }

  depends_on = [yandex_compute_disk.storage_disk]
}