variable "project-id" {
  type = string
}

variable "vpc_name" {
  default = "boundary-vpc"
  type    = string
}

variable "public-subnet" {
  default = "boundary-public-subnet"
  type    = string
}

variable "private-subnet" {
  default = "boundary-private-subnet"
  type    = string
}
variable "vault-name" {
  type = string
}
variable "region" {
  type = string
}

variable "zone" {
  type = string
}
