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