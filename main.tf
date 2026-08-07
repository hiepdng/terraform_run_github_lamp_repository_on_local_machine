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
      # Load .env file variables
      if [ -f .env ]; then
        while IFS= read -r line || [ -n "$line" ]; do
          # Skip comments and empty lines
          [[ "$line" =~ ^#.*$ ]] || [ -z "$line" ] && continue
          echo "$line" >> $GITHUB_ENV
        done < .env
      else
        echo ".env file not found"
      fi
      # Remove contrainers
      if [ -d "docker_build_DHI_LAMP_Project" ]; then
        cd docker_build_DHI_LAMP_Project
        docker compose down || docker-compose down
      fi
      # Remove images
      docker rmi "${PROJECT_NAME}-${HTTPDVERSION}" || true
      docker rmi "${PROJECT_NAME}-${MYSQLVERSION}" || true
      docker rmi "${PROJECT_NAME}-${PHPVERSION}"  || true
      # Remove docker network
      docker network ls --filter name=lamp_network -q |xargs -r docker network rm
    EOT
  }
}
