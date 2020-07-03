
####################### Variables #############################

variable "private_key_path"{
  type = string
  default = "/home/vagrant/terraform_samples/MyKeyPair.pem"
}  

variable "ssh_user"{
  type = string
  default = "ec2-user" 
}

variable "key_name"{
  type = string
  description = "key name"
  default = "MyKeyPair" 
}

variable "region" {                                                                                                                                                                                                  type    = string
  default = "eu-west-1"
  description = "Name of the region to create resource"
}

variable "network_address_space" {                               
     default = "10.1.0.0/16"                                                                                                                                                   default = "10.1.0.0/16"
}

variable "subnet_address_space" {                               
     default = "10.1.0.0/24"                                                                                                                                                   default = "10.1.0.0/16"
}






