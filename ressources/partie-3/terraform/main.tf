# main.tf — étape 2 : image, réseau et parc de serveurs

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

# Un appel du module « serveur » PAR entrée de var.serveurs
module "serveur" {
  source   = "./modules/serveur"
  for_each = var.serveurs

  nom       = "${var.prefixe}-${each.key}"
  image_id  = docker_image.cible.image_id
  reseau    = docker_network.reseau.name
  port_ssh  = each.value.port_ssh
  port_http = each.value.port_http
}
