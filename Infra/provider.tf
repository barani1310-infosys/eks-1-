terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_pet" "cluster_name" {
  length    = 2
  separator = "-"
  prefix    = "eks"
}

resource "random_id" "cluster_suffix" {
  byte_length = 4
}

locals {
  dynamic_cluster_name = "${random_pet.cluster_name.id}-${random_id.cluster_suffix.hex}"
}