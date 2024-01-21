Infrastructure Deployment and Cloud Build Process
1. Configure Terraform Variables (terraform.tfvars)
   hcl
   Copy code
# terraform.tfvars

aws_access_key         = "ASIAXAN…GCWZWWX"
aws_secret_key         = "Z5f7Q160q…lc6waySfG"
aws_token              = "FwoG…cS0FY="

socket_container_port  = 3001
connect4_container_port= 80

socket_container_image = "ducthuanle/cc_socket-server:latest"
connect4_container_image= "ducthuanle/cc_react-app:latest"

deploy_ecs_services     = false
2. Set AWS Credentials and Execute Terraform
   bash
   Copy code
# Run the following commands in the root directory

terraform init
terraform plan
terraform apply
This initializes and deploys AWS services, excluding ECS services.

3. Update and Push .env to GitHub
   Update the .env file with the following content:

env
Copy code
REACT_APP_ALB_HOSTNAME=socket-ecs-lb-721208492.us-east-1.elb.amazonaws.com
REACT_APP_SOCKET_PORT=3001
Copy the output variable for socket_hostname and paste it into REACT_APP_ALB_HOSTNAME. Commit and push changes. Wait for the "CD Docker Image + DockerHub push" pipeline to complete.

4. Deploy ECS Services
   Update terraform.tfvars:

hcl
Copy code
# terraform.tfvars

deploy_ecs_services = true
Run Terraform again:

bash
Copy code
terraform plan
terraform apply
This deploys ECS infrastructure with the latest Docker build and correct Socket URL.

5. Access React App LB Hostname
   bash
   Copy code
   alb_hostname = "ecs-lb-571829938.us-east-1.elb.amazonaws.com"
   Press start and wait until connected to the socket (check developer console). Join a room and follow game instructions. Do not join a room before connecting to the socket.