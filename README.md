## Terraform runs a GitHub LAMP repository on a local machine

The GitHub LAMP repository to use is 
[https://github.com/hiepdng/docker_build_DHI_LAMP_Project](https://github.com/hiepdng/docker_build_DHI_LAMP_Project)  
<br/>

This is LAMP stack project used with Docker Compose and hardened Docker images listed below:  
  - Apache image: [dhi.io/httpd:2.4.68-debian13](https://hub.docker.com/hardened-images/catalog/dhi/httpd)  
  - MySQL image: [dhi.io/mysql:lts-debian13](https://hub.docker.com/hardened-images/catalog/dhi/mysql)  
  - PHP image: [dhi.io/php:8.5.8-debian13-fpm](https://hub.docker.com/hardened-images/catalog/dhi/php)

<br/>

**Steps to run:**  
1.Save the file named main.tf in an empty directory.  

2.Initialize Terraform:  
```
terraform init
```  

3.Deploy the stack:  
```
terraform apply -auto-approve
```  

4.Stop and remove the stack:  
```
terraform destroy -auto-approve
```  
