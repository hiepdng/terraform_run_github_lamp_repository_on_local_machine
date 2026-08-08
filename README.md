## Terraform runs a GitHub LAMP repository on a local machine

The GitHub LAMP repository to use is 
[https://github.com/hiepdng/docker_build_DHI_LAMP_Project](https://github.com/hiepdng/docker_build_DHI_LAMP_Project)  
<br/>

This is LAMP stack project used with Docker Compose and hardened Docker images listed below:  
  - Apache image: [dhi.io/httpd:2.4.68-debian13](https://hub.docker.com/hardened-images/catalog/dhi/httpd)  
  - MySQL image: [dhi.io/mysql:lts-debian13](https://hub.docker.com/hardened-images/catalog/dhi/mysql)  
  - PHP image: [dhi.io/php:8.5.8-debian13-fpm](https://hub.docker.com/hardened-images/catalog/dhi/php)

<br/>


#### <ins>Method 1:</ins> Deploy LAMP Stack using CLI

1. Login to dockerhub in your terminal  
```
docker login dhi.io
```
2. Initialize Terraform:  
```
terraform init
```  
3. Deploy the LAMP stack:  
```
terraform apply -auto-approve
```
4. Stop and remove the LAMP stack:  
```
terraform destroy -auto-approve
```

#### <ins>Method 2:</ins> Deploy LAMP Stack using GitHub Actions
- Set up your DOCKERHUB_USERNAME and DOCKERHUB_TOKEN secrets in GitHub Actions.
- The provided GitHub Action is for deploying the LAMP Stack on local machine (self-hosted runner.) And they are triggered by workflow_dispatch. Change to other trigger if you wish.
  - To register a Local Self-Hosted Runner, flow the below steps:
    - In your GitHub repo, go to Settings > Actions > Runners > New self-hosted runner.
    - Download and configure the runner package on your local machine, then start it (./run.sh).
- There are two Gihub Actions workflow files (deploy.yml and cleanup.yml).
    - deploy.yml: Deploy the LAMP Stack on your local machine.
    - cleanup.yml: Delete all infrastructure resources, remove Docker containers and docker network.

<br/><br/>

### Basic docker commands:
```
$ docker pull <image_name>       – Pulls an image from dockerhub
$ docker image ls                – Lists all locally stored Docker images on your host system
$ docker run -d <image_name>     – Creates & starts a new Docker container from animage and runs it in the background
  docker run -it -d --name image_name <image_name>
$ docker ps                      – Lists all currently running Docker container IDs on your system
$ docker ps -a                   – lists all Docker container IDs on your system, regardless of their current status. 
$ docker stop <containerID>      – Gracefully shuts down a running Docker container
$ docker start <containerID>     – Resumes and boots up stopped Docker container
$ docker rm <containerID>        – Remove Docker container

$ docker exec -it <containerID> bash – Opens an interactive command-line terminal (Bash) inside a Docker
                                       container that is already running.
