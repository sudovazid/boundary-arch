variable "project-id" {
  type = string
}
variable "region" {
  type    = string
  default = "us-central1"
}
variable "zone" {
  type    = string
  default = "us-central1-c"
}
variable "credentials" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "public-subnet" {
  type = string
}
variable "private-subnet" {
  type = string
}
variable "vault-name" {
  type = string
}