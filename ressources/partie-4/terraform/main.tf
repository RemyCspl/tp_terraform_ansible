# main.tf — image, réseau, parc de serveurs et inventaire Ansible

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

# Regrouper les noms de serveurs par groupe Ansible :
#   { api = ["api1", "api2"], db = ["db1"], lb = ["lb1"] }
locals {
  groupes = {
    for groupe in distinct([for s in values(var.serveurs) : s.groupe]) :
    groupe => sort([for nom, s in var.serveurs : nom if s.groupe == groupe])
  }
}

# L'inventaire Ansible, ÉCRIT par Terraform à partir d'un gabarit
resource "local_file" "inventaire" {
  filename        = "${path.module}/../ansible/inventory.ini"
  file_permission = "0644"

  content = templatefile("${path.module}/templates/inventory.ini.tftpl", {
    groupes  = local.groupes
    serveurs = var.serveurs
    prefixe  = var.prefixe
    cle_ssh  = var.cle_ssh_privee
  })

  # N'écrire l'inventaire qu'une fois les conteneurs créés
  depends_on = [module.serveur]
}
