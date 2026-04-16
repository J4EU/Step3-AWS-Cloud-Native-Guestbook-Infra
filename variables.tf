variable "my_ip" {
  description = "My public IP address for SSH access"
  type        = string
}

variable "was_instance_type" {
  default = "t4g.micro"
}

variable "rds_password" {
  description = "RDS admin's password"
  type        = string
}
