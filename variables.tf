locals {
  region       = "ap-northeast-1"
  cluster_name = "isseeeeey55-eks"
}

variable "common" {
  type = map(string)

  default = {
    prefix = "isseeeeey55"
    key_name     = "aws-isseeeeey55-ap-northeast-1"
  }
}

variable "workers_additional_policies" {
  description = "Additional policies to be added to workers"
  type        = list(string)

  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::XXXXXXXXXXXX:user/isseeeeey55"
      username = "isseeeeey55"
      groups   = ["system:masters"]
    },
  ]
}
