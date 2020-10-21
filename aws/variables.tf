variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.large"
}

variable "cluster_prefix" {
  type = string
}

variable "control_plane_size" {
  type = string
  default = "1"
  description = "# of control plane nodes {1,3,5}"
}

variable "worker_pool_size" {
  type = string
  default = "1"
  description = "# of worker nodes"
}

variable "vpc_id" {
  type = string
}

variable "domain" {
  type = string
  description = "hosted zone name used for domain name (no trailing dot)"
}

variable "acm_certificate_domain" {
  type = string
  description = "The exact domain value of the acm certificate when terminating TLS for cs-ui (optional)"
  default = null
}

variable "kubernetes_version" {
  type = string
  default = "1.16.7"
}

variable "cluster_backup" {
  type = bool
  default = true
}

variable "issuer_domain" {
  type = string
  description = "override the issuer domain (optional)"
  default = null
}

variable "issuer_trust_system_ca" {
  type = bool
  description = "issuer will trust any certificates used by the system (T/F) (optional)"
  default = null
}

variable "apiserver_alt_names" {
  type = list(string)
  description = "SANs added to the kube-apiserver certificate (optional)"
  default = null
}

variable "apiserver_url" {
  type = string
  description = "URL for kube-apiserver. It should only be set if the URL is not using the cluster domain. This will only be used to set exported kubeconfigs in the UI (optional)"
  default = null
}
