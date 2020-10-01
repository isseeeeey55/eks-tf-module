module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = local.cluster_name
  cluster_version                 = "1.17"
  vpc_id                          = module.vpc.vpc_id
  subnets                         = "${concat(module.vpc.public_subnets, module.vpc.private_subnets)}"
  cluster_enabled_log_types       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_endpoint_private_access = "true"

  tags = {
    "Terraform"          = "true",
    "TerraformModule"    = "terraform-aws-modules/eks/aws",
    "datadog_monitoring" = "disable",
  }

  worker_groups_launch_template = [
    {
      name                          = "ng-1"
      key_name                      = var.common["key_name"]
      instance_type                 = "m5.large"
      public_ip                     = "true"
      asg_desired_capacity          = 4
      asg_min_size                  = 4
      asg_max_size                  = 8
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]

      # Settings for launch templates with mixed instances policy
      override_instance_types                  = ["m5.large", "m5a.large", "m5d.large", "m4.large"]
      on_demand_base_capacity                  = 2
      on_demand_percentage_above_base_capacity = 50
      spot_instance_pools                      = 4
      spot_max_price                           = "0.20"
      kubelet_extra_args                       = "--node-labels=node.kubernetes.io/lifecycle=`curl -s http://169.254.169.254/latest/meta-data/instance-life-cycle`"
    },
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  workers_additional_policies          = var.workers_additional_policies
  map_users                            = var.map_users
}
