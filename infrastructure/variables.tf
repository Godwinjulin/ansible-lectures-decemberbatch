variable "instance_type" {
  description = "Instamce size of ubuntu server"
  type        = string
  default     = "t2.micro"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zone" {
  type    = string
  default = "us-east-2a"
}


///Modules vpc variables
/////VPC variables

variable "cidr_block1" {
  type    = string
  default = "10.0.0.0/24"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_hostnames" {
  type    = string
  default = "true"
}

variable "tags" {
  type    = map(string)
  default = {}
}

///Subnet Variables
variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.0.96/27", "10.0.0.32/27", "10.0.0.64/27"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.0.128/27", "10.0.0.160/27", "10.0.0.192/27"]
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

////security group variables
variable "security_group_ingress" {
  description = "List of maps of ingress rules to set on the security group"
  type        = list(map(string))
  default     = []
}

variable "security_group_egress" {
  description = "List of maps of ingress rules to set on the security group"
  type        = list(map(string))
  default     = []
}