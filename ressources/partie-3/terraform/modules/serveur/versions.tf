# versions.tf — un module DOIT déclarer les providers qu'il utilise.
# Sans ce bloc, Terraform chercherait « hashicorp/docker », qui n'existe pas.
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}
