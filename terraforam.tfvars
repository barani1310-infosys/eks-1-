environment = "prod"
region      = "ap-south-1"

vpc_cidr = "10.0.0.0/16"

public_subnets  = ["130.70.1.0/24", "130.70.2.0/24"]
private_subnets = ["130.70.3.0/24", "130.70.4.0/24"]

cluster_version = "1.28"

node_group_instance_types = ["t2.micro", "t2.micro"]

public_node_desired_size = 1
public_node_max_size     = 2
public_node_min_size     = 1

private_node_desired_size = 1
private_node_max_size     = 2
private_node_min_size     = 1

tags = {
  Environment = "production"
  Team        = "devops"
  Application = "microservices"
}