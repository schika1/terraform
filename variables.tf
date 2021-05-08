#DEFINES AWS REGION
variable "AWS_REGION" {
    type = string
    default = "eu-west-1"
}

# INSTANCE USERNAME
variable "INSTANCE_USERNAME" {
  type = string
  default = "ubuntu"
}

#PATH TO THE PRIVATE KEY
variable "PATH_TO_PRIVATE_KEY" {
  default = "key"
}

# PATH TO THE PUBLIC KEY
variable "PATH_TO_PUBLIC_KEY" {
  default = "key.pub"

}

# DEFAULT CIDR
variable "default_cidr" {
  type = list
  default = ["0.0.0.0/0"]
}

# DEFAULT CIDR IPV6
variable "default_cidr_ipv6" {
  type = list
  default = ["::/0"]
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}