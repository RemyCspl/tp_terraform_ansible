# main.tf — un « serveur » = un conteneur systemd joignable en SSH
resource "docker_container" "serveur" {
  name     = var.nom
  hostname = var.nom
  image    = var.image_id

  # systemd a besoin de ces réglages pour tourner dans un conteneur
  privileged = true
  tmpfs = {
    "/run"      = ""
    "/run/lock" = ""
  }

  # Redémarre avec Docker (par exemple après un redémarrage de WSL)
  restart = "unless-stopped"

  networks_advanced {
    name = var.reseau
  }

  # SSH : uniquement depuis le poste (127.0.0.1), jamais depuis l'extérieur
  ports {
    internal = 22
    external = var.port_ssh
    ip       = "127.0.0.1"
  }

  # HTTP : bloc « dynamic » = 0 ou 1 bloc ports selon que port_http est fourni
  dynamic "ports" {
    for_each = var.port_http == null ? [] : [var.port_http]
    content {
      internal = 80
      external = ports.value
    }
  }
}
