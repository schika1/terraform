variable "AWS_REGION" {
    type = string
    default = "eu-west-1"
}

variable "INSTANCE_USERNAME" {
  type = string
  default = "ubuntu"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "levelup_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "levelup_key.pub"
}

variable "default_cidr" {
  type = list
  default = ["0.0.0.0/0"]
}

variable "default_cidr_ipv6" {
  type = list
  default = ["::/0"]
}