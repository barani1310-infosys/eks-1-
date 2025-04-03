variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "130.70.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["130.70.1.0/24", "130.70.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["130.70.3.0/24", "130.70.4.0/24"]
}

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.28"
}

variable "node_group_instance_types" {
  description = "Instance types for node groups"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "public_node_desired_size" {
  description = "Desired number of public nodes"
  type        = number
  default     = 1
}

variable "public_node_max_size" {
  description = "Maximum number of public nodes"
  type        = number
  default     = 2
}

variable "public_node_min_size" {
  description = "Minimum number of public nodes"
  type        = number
  default     = 1
}

variable "private_node_desired_size" {
  description = "Desired number of private nodes"
  type        = number
  default     = 1
}

variable "private_node_max_size" {
  description = "Maximum number of private nodes"
  type        = number
  default     = 2
}

variable "private_node_min_size" {
  description = "Minimum number of private nodes"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}