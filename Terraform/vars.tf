variable "region_aws" {
  type = string
  default = "us-east-1"
  description = "Região Padrão Utilizada para o desenvolvimento do projeto"
}
variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
  default = "admin"
}
variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
  default = "123456Aa"
}
