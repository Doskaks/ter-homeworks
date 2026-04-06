resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# Создание облачной сети
resource "yandex_vpc_network" "default" {
  name = "network-1"
}

# Создание подсети
resource "yandex_vpc_subnet" "default" {
  name           = "subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Получение последней версии Ubuntu 22.04 LTS
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}