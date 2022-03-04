/////VPC variables

variable "cidr_block" {
  type = string
}

variable "instance_tenancy" {
  type = string
}

variable "enable_dns_hostnames" {
  type = string
}

///Subnet Variables
variable "map_public_ip_on_launch" {
  type    = bool
  default = false
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}

///security group variables
variable "security_group_ingress" {
  description = "List of maps of ingress rules to set on the security group"
  type        = any
  default     = []
}


variable "security_group_egress" {
  description = "List of maps of ingress rules to set on the security group"
  type        = any
  default     = []
}


variable "tags" {
  type    = map(string)
  default = {}
}

variable "security_group" {
  description = "Should be true to adopt and manage default security group"
  type        = bool
  default     = true
}