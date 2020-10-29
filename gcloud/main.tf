
provider "google" {
  credentials = file("prefab-mountain-292413-8ee3c7307748.json")
  project     = "prefab-mountain-292413"
  region      = "us-central1"
  zone        = "us-central1-a"
  user_project_override = true
}



resource "google_compute_instance" "test_instans" {
  name = "terraform${count.index}"
  count = 2
  machine_type = "e2-medium"
//  metadata = {
//    ssh-keys = "samirshahubs:${file("id_rsa.pub")}"
//  }
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20201014"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  provisioner "remote-exec" {
    inline = [
          "echo ${self.network_interface.0.access_config.0.nat_ip} >> ~/pub_ip_address.txt",
          "sudo apt install apache2",
          "sudo systemctl status apache2",
          "sudo systemctl is-enabled apache2",
          "sudo apt install mariadb-server mariadb-client",
          "sudo systemctl status mariadb",
          "sudo systemctl is-enabled mariadb",
          "sudo mysql_secure_installation",
          "mysql -u root -p",
          "sudo mysql -u root",
          "sudo apt install php libapache2-mod-php php-mysql",
          "sudo apt-cache search php | grep php-",
          "sudo apt install php-redis php-zip",
          "sudo systemctl restart apache2",
          "sudo echo <?php phpinfo();?> >> /var/www/html/info.php"

      ]

    connection {
          type = "ssh"
          user = "samirus"
          private_key = file("/home/samirus/.ssh/id_rsa")
          host = self.network_interface.0.access_config.0.nat_ip
      }
  }
}

resource "google_compute_firewall" "default" {
  name    = "terraformfirewall"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80", "9090", "22"]
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-network-145"
  auto_create_subnetworks = "true"
}

output "ip" {
  value = google_compute_instance.test_instans.*.network_interface.0.access_config.0.nat_ip
}