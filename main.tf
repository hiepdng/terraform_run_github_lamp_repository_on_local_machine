terraform {
  required_version = ">= 1.0.0"
  backend "local" {
    path = "/home/temp/z/b/actions-runner/terraform.tfstate"
  }
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

resource "null_resource" "lamp_stack" {
  triggers = {
    repo_url = "https://github.com/hiepdng/docker_build_DHI_LAMP_Project.git"
    dir_name = "docker_build_DHI_LAMP_Project"
  }

  provisioner "local-exec" {
    command = <<EOT
      if [ ! -d "${self.triggers.dir_name}" ]; then
        git clone ${self.triggers.repo_url}
      fi
      cd "${self.triggers.dir_name}"
      sh setup.sh
      docker compose up -d || docker-compose up -d
    EOT
  }

provisioner "local-exec" {
    when        = destroy
    on_failure  = fail
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      if [ ! -d "${self.triggers.dir_name}" ]; then
        git clone ${self.triggers.repo_url}
      fi
      cd "${self.triggers.dir_name}"
      docker compose down -v || docker-compose down -v || true
    EOT
  }
}
