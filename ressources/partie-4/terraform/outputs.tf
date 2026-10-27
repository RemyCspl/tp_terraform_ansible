# outputs.tf — ce que le projet affiche après un apply
output "conteneurs" {
  description = "Nom court => nom du conteneur et port SSH"
  value = {
    for nom, serveur in module.serveur :
    nom => "${serveur.nom} (ssh 127.0.0.1:${serveur.port_ssh})"
  }
}

output "inventaire_ansible" {
  description = "Chemin de l'inventaire généré pour Ansible"
  value       = abspath(local_file.inventaire.filename)
}

output "url_stockline" {
  description = "URL publique de StockLine (via le répartiteur nginx)"
  value       = "http://localhost:8080"
}
