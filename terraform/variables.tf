variable "infra_version" {
    type = string
}

variable "infra_repo" {
    type = string
}

variable "infra_environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az_use_count" {
  type = number
  default = 2
}