terraform {
  required_version = ">= 1.0.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

resource "null_resource" "lamp_stack" {
  # Trigger re-execution if the repository URL changes
  triggers = {
    repo_url = "https://github.com/hiepdng/docker_build_DHI_LAMP_Project.git"
  }

  # Clone repository and launch containers
  provisioner "local-exec" {
    command = <<EOT
      if [ ! -d "docker_build_DHI_LAMP_Project" ]; then
        git clone https://github.com/hiepdng/docker_build_DHI_LAMP_Project.git
      fi
      cd docker_build_DHI_LAMP_Project
      sh setup.sh
      docker compose up -d || docker-compose up -d
    EOT
  }

  # Shut down containers when running terraform destroy
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      # Remove contrainers
      docker compose down || docker-compose down
      docker rmi $(docker images --filter "reference=lamp-*" -q)
      # Remove docker network
      docker network ls --filter name=lamp_network -q |xargs -r docker network rm
    EOT
  }
}
