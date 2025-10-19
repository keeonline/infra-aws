terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "5.87.0"
      }
    }
}

provider "aws" {
    default_tags {
      tags = {
        InfraEnvironment = "${var.infra_environment}"
        IacVersion = "${var.infra_version}"
        IacRepo = "${var.infra_repo}"
      }
    }
}