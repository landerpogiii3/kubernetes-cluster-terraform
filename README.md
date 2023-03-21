# kubernetes-cluster-terraform
This repo contains integration of terraform modules that spin up Kubernetes cluster on AWS through terraform.

AWS's Elastic Kubernetes Service (EKS) is a managed service that lets you deploy, manage, and scale containerized applications on Kubernetes. 

This documentation provides explanations on how publicly available terraform modules were configured and used, and how kubectl can be used to verify that deployed cluster is ready to use. 

EKS relies on network configurations for it to be accessible and secure. To enable this, a VPC must be configured together with other underlying infrastructure such as Subnets, Routes, Gateways, and Security Groups. Luckily, terraform has a publicly available module to easily set this up. Instead of reinventing the wheel, I used this instead. 

VPC 

More information of the VPC module [here](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest "vpc")

## Inputs description ##

**name**:   The default value for this input is = “”. To customize this, I configured the variable var.vpc_name = "dimacali-vpc" 

**cidr**:   The CIDR block I used is a class B network 

**azs**:    Accepts a list of AZs in string. The slice function extracts some consecutive elements within a list. 

**private_subnets**:    A list of private subnet CIDR blocks 

**public_subnets**: A list of private subnet CIDR blocks 

**enable_nat_gateway**: Whether to setup a NAT Gateway (so that private subnets may access the internet) 

**single_nat_gateway**: Should be true if you want to provision a single shared NAT Gateway across all of your private networks 

**enable_dns_hostnames**:   Whether to enable DNS hostnames in the Default VPC 

*Note*:   The default value for the last three inputs is set to false which is why they are explicitly set to true 

**[public | private ]_subnet_tags**:    Map of tags to be attached to specified subnets

## EKS ##
More information about the EKS module [here](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest "eks")

**cluster_name**:   The name of the EKS cluster. The value I have set for this is = to "dimacali-EKS-cluster" 

**cluster_version**:    The EKS cluster version to use. 

**vpc_id**: The ID of the VPC that was previously created. 

**subnet_ids**: A list of the IDs of the subnets in the same VPC 

**cluster_endpoint_public_access**: Whether or not the Amazon EKS public API server endpoint is enabled 

**eks_managed_node_group_defaults**:    Adds the value for ami_type to the filter block that selects the AMI to use. 

**eks_managed_node_groups**:    Map of EKS managed node group definitions to create 

**name**:   The name to give to the node. I have set this to “dimacali-node-group-1” 

**instance_types**: Sets the instance type to use. I used t3.small. 

**min_size**:   The minimum count of instances in a node. Set to 1 

**max_size**:   The maximum count of instances in a node. Set to 3 

**desired_size**:   The desired count of instances in a node. Set to 2 

## Addon: EBS ##

More information on [Assuming Role with OIDC](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-assumable-role-with-oidc "module iam") and EKS [addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon "eks addon")

**create_role**:	By default, this is set to false. To use this module, the value for this input must be set to true. 

**role_name**:	The name of the role to create. For tracking and manageability, the EKS cluster name was concatenated. 

**provider_url**:	The URL of the OIDC Provider. 

**role_policy_arns**:	The ARN of IAM policy. The value set to this input is = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" 

**oidc_fully_qualified_subjects**:	The fully qualified OIDC subjects to be added to the role policy. 

**cluster_name**:	The name of the EKS Cluster. 

**addon_name**:	The name of the EKS addon to select 

**addon_version**:	The version of the EKS addon 

**service_account_role_arn**:	The ARN of the recently created IAM role to bind to the addon's service account. 

**tags**:	Map of tags to attach to the addon.

When applied, this will create the Kubernetes cluster managed by AWS EKS. To see the leader of the node, install kubectl on the same workstation you applied the terraform code. 

You can do this by executing the following: 

Download the latest release: 

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" 

Validate the binary 

    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum –check 

 The output should be: 

    kubectl: OK 

Install kubectl 

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl 

Once the terraform code is done, you need to configure kubectl to interact with it. 

First, open the outputs.tf file to review the output values. You will use the region and cluster_name outputs to configure kubectl. 

Run the following command to retrieve the access credentials for your cluster and configure kubectl. 

    aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name