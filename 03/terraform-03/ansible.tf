# Создание inventory файла для Ansible с использованием templatefile
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.web
    databases  = yandex_compute_instance.database
    storage_vm = [yandex_compute_instance.storage] # Одиночная ВМ в списке
  })
  filename = "${abspath(path.module)}/hosts.ini"
}