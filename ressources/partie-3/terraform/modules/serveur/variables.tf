# variables.tf — les ENTRÉES du module « serveur » (son contrat)
variable "nom" {
  type        = string
  description = "Nom du conteneur (et nom DNS sur le réseau Docker)"
}

variable "image_id" {
  type        = string
  description = "Identifiant de l'image Docker à utiliser"
}

variable "reseau" {
  type        = string
  description = "Nom du réseau Docker à rejoindre"
}

variable "port_ssh" {
  type        = number
  description = "Port du poste redirigé vers le port 22 du conteneur"
}

variable "port_http" {
  type        = number
  description = "Port du poste redirigé vers le port 80 du conteneur (null = aucun)"
  default     = null
}
