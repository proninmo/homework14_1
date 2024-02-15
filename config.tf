terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.81.0"
    }
  }
}

// Configure the Yandex.Cloud provider
//test commit
provider "yandex" {
#  token                    = ""
  service_account_key_file = "./key.json"
  cloud_id                 = "b1g5h324cthaptno5nqf"
  folder_id                = "b1g2f8n81gpa25g6i9sg"
  zone                     = "ru-central1-a"
}

// Create a new instance

resource "yandex_compute_instance" "vm-1" {

  name        = "linux-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8egv6phshj1f64q94n"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-111.id}"
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
     }
}

resource "yandex_vpc_network" "network-111" {
  name = "network111"
}

resource "yandex_vpc_subnet" "subnet-111" {
  name           = "subnet111"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.4.4.0/28"]
  network_id     = "${yandex_vpc_network.network-111.id}"
}