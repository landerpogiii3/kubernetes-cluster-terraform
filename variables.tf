variable "aws_region" {
  description = "Preferred AWS Region"
  type = string
  default = "ap-southeast-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
  default = "dimacali-EKS-cluster"
}

variable "node_group_1_name" {
  description = "The name of group 1 node"
  type = string
  default = "dimacali-node-group-1"
}

variable "node_group_2_name" {
  description = "The name of group 1 node"
  type = string
  default = "dimacali-node-group-2"
}

variable "instance_type" {
  description = "EC2 Instance types"
  type = string
  default = "t3.small"
}

variable "min_size" {
  description = "Minimum size of the node"
  type = number
  default = 1
}

variable "max_size" {
  description = "Maximum size of the node"
  type = number
  default = 3
}

variable "desired_size" {
  description = "Desired size of the node"
  type = number
  default = 2
}

variable "policy_arn" {
  description = "The ARN of the Policy set as string"
  type = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

variable "eks_addon_name" {
  description = "The name of the EKS EBS-CSI addon"
  type = string
  default = "aws-ebs-csi-driver"
}

variable "eks_addon_version" {
  description = "The version of the EKS EBS-CSI addon"
  type = string
  default = "v1.5.2-eksbuild.1"
}

variable "eks_addon_tags" {
  description = "The tags for the EKS addon"
  type = map
  default = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"    
  }
}

variable "vpc_name" {
  description = "The name of VPC to be created"
  type = string
  default = "dimacali-vpc"
}