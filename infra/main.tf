terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"

}

# VPC simplificada para AWS Academy (sin NAT Gateway para reducir costos)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "retailmax-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]  # Reducido a 2 AZs
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  # Eliminamos private_subnets para evitar necesidad de NAT Gateway

  enable_nat_gateway   = false  # Deshabilitado para reducir costos
  enable_dns_hostnames = true

  tags = {
    Project = "retailmax"
  }
}

# Comentado temporalmente el EKS - muy costoso para AWS Academy
# Recomendación: usar EC2 instances simples o ECS Fargate en su lugar
/*
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "retailmax-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets  # Cambiado a public_subnets

  # Nodo(s) administrados con instancias más pequeñas
  eks_managed_node_groups = {
    general = {
      instance_types = ["t3.micro"]  # Cambio a t3.micro para AWS Academy
      min_size       = 1
      max_size       = 2             # Reducido para limitar costos
      desired_size   = 1
    }
  }

  tags = {
    Project = "retailmax"
  }
}
*/

# Alternativa más económica: EC2 simple para pruebas
resource "aws_instance" "retailmax_app" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  instance_type = "t2.micro"               # Incluido en free tier
  
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  
  tags = {
    Name = "retailmax-app-server"
    Project = "retailmax"
  }
}
