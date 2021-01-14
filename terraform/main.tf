terraform {
  backend "local" {
    path = ".local-backend/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# 4893 is the IAM account; sandbox is 888458450351
provider "aws" {
  region = "us-east-1"

  allowed_account_ids = ["888458450351"]

  assume_role {
    role_arn = "arn:aws:iam::888458450351:role/JsllcMainAccountAdministratorAccess"
  }
}

module "network" {
  source       = "./modules/network"
  project_name = var.project_name
}

module "eks_cluster" {
  source       = "./modules/eks-cluster"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.app_subnet_ids
}

module "code_pipeline" {
  source       = "./modules/code-pipeline"
  project_name = var.project_name
}
