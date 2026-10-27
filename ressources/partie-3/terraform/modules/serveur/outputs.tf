# outputs.tf — les SORTIES du module « serveur »
output "nom" {
  description = "Nom du conteneur créé"
  value       = docker_container.serveur.name
}

output "port_ssh" {
  description = "Port SSH du poste vers ce conteneur"
  value       = var.port_ssh
}
