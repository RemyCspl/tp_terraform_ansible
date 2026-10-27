# variables.tf — les paramètres du projet
variable "prefixe" {
  type        = string
  description = "Préfixe de tous les noms Docker créés par ce projet"
  default     = "tp-iac"
}

variable "cle_ssh_privee" {
  type        = string
  description = "Clé privée qu'Ansible utilisera pour se connecter aux serveurs"
  default     = "~/.ssh/tp_iac_ed25519"
}

# Le parc de serveurs : une entrée = un conteneur.
#   groupe    : groupe Ansible du serveur (db, api ou lb)
#   port_ssh  : port du poste redirigé vers son SSH
#   port_http : port du poste redirigé vers son port 80 (facultatif)
variable "serveurs" {
  type = map(object({
    groupe    = string
    port_ssh  = number
    port_http = optional(number)
  }))
  description = "Serveurs à créer, indexés par leur nom court"

  default = {
    db1  = { groupe = "db", port_ssh = 2241 }
    api1 = { groupe = "api", port_ssh = 2242 }
    api2 = { groupe = "api", port_ssh = 2243 }
    lb1  = { groupe = "lb", port_ssh = 2244, port_http = 8080 }
  }
}
