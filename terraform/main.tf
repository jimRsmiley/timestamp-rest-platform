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
  source                          = "./modules/code-pipeline"
  project_name                    = var.project_name
  service_s3_deploy_conf_zip_key  = "timestamp-app.zip"
  codebuild_source_s3_bucket_name = "tf-codepipeline-source-${var.project_name}"
}
