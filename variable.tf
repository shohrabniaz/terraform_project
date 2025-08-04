#variable
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-1"  
}


variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr_block" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr_block" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet1_cidr_block" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet2_cidr_block" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone1" {
  description = "The first availability zone to be used"
  type        = string
  default     = "us-west-1a"
  #default = "us-east-2a"
}

variable "availability_zone2" {
  description = "The second availability zone to be used"
  type        = string
  default     = "us-west-1b"
  #default = "us-east-2c"
}
