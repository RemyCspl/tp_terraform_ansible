# main.tf — étape 1 : l'image cible et le réseau

# L'image construite à partir de ../image-cible/Dockerfile
resource "docker_image" "cible" {
  name = "${var.prefixe}-cible:1.0"

  build {
    context = "${path.module}/../image-cible"
  }

  # Reconstruire l'image si le Dockerfile ou la clé autorisée changent
  triggers = {
    dockerfile = filesha1("${path.module}/../image-cible/Dockerfile")
    cle        = filesha1("${path.module}/../image-cible/authorized_keys")
  }

  # terraform destroy supprime aussi l'image
  keep_locally = false
}

# Le réseau privé des conteneurs : ils s'y joignent par leur NOM (DNS Docker)
resource "docker_network" "reseau" {
  name = "${var.prefixe}-net"
}
