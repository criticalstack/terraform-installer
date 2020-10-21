data "aws_caller_identity" "current" {}

resource "random_pet" "cluster" {}

locals {
  account_id             = data.aws_caller_identity.current.account_id
  current_user           = data.aws_caller_identity.current.arn
  cluster_name           = "${var.cluster_prefix}-${random_pet.cluster.id}"
  control_plane_endpoint = "${local.cluster_name}.${var.domain}"
}
