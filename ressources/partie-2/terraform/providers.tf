# providers.tf — versions de Terraform et des providers, épinglées
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    # Pilote le Docker Engine de votre WSL (images, réseaux, conteneurs)
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
    # Écrit des fichiers sur votre poste (ici : l'inventaire Ansible)
    local = {
      source  = "hashicorp/local"
      version = "2.9.1"
    }
  }
}

# Sans argument : le provider parle au Docker local (socket /var/run/docker.sock)
provider "docker" {}
