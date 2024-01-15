#### How to Use the Terraform Repo
Clone the repository to your local machine.
Set up your AWS credentials using environment variables or AWS shared credentials file.
Modify the vpc_id and subnet_ids variables in the terraform.tfvars file to match your existing VPC and subnet configuration.
Run terraform init to initialize the working directory and download the required providers.
Run terraform apply to create the EKS cluster and associated resources.

####  Demonstration for End-User
Once the EKS cluster is deployed, an end-user (developer) can run a pod on the new EKS cluster using the following steps:
Configure the kubectl command-line tool to communicate with the EKS cluster using the provided eks_cluster_endpoint and eks_cluster_certificate_authority_data.
Create an IAM role and attach the pod-assume-role-policy to it.
Configure the pod to assume the IAM role created in the previous step using the appropriate annotations in the pod's manifest file.
Run the pod on the EKS cluster and verify that it can access an S3 bucket using the IAM role assigned.