# outputs.tf — ce que le projet affiche après un apply
output "conteneurs" {
  description = "Nom court => nom du conteneur et port SSH"
  value = {
    for nom, serveur in module.serveur :
    nom => "${serveur.nom} (ssh 127.0.0.1:${serveur.port_ssh})"
  }
}
