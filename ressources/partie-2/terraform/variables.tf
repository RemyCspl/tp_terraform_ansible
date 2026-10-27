# variables.tf — les paramètres du projet
variable "prefixe" {
  type        = string
  description = "Préfixe de tous les noms Docker créés par ce projet"
  default     = "tp-iac"
}
