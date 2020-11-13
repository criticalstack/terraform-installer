## Critical Stack Terraform Installer Reference

This repo contains reference files for a minimal installation of Kubernetes using the Critical Stack cluster bootstrapping components. 

The main Terraform here provisions a barebones Kubernetes cluster in AWS using our provisioning tools such as `e2d` and `crit`. It is *not* a full featured Critical Stack install - for that, start with [Crit/Cinder](https://github.com/criticalstack/crit) and check out the [Critical Stack UI](https://github.com/criticalstack/ui). It does not include opinionated configuration of or on top of Kubernetes like PSPs, encryption configs, or even a default StorageClass.

It will just, and _only just_, deploy a usable cluster. Do not deploy this to production.


### Deploying

`make`

### Destroying

`make destroy`

### How it works

All configuration for the AWS infrastructure is done via options listed in `variables.tf` - `make config-confirm` will run a helpful wizard that will write a `terraform.tfvars` when complete. A VPC and private subnets (named `*private*`) are assumed to exist and be specified. Security groups and an S3 bucket are created for the cluster, and control plane and worker pool ASGs are deployed. The cluster CA is generated locally and pushed to S3 for the nodes to access.

The contents of the `userdata` directory is consumed by the `cloudinit` module and deployed to the cluster nodes (control plane and worker pools respectively). All nodes configure the system minimally (setting up kubelet/containerd cgroups) and install dependencies. Control plane nodes initialize `e2d` and, once there is quorum, bootstrap Kubernetes via `crit` and deploy a CNI (Cilium) via Helm.

## Contributing

Any contributors must accept and [sign the CLA](https://cla-assistant.io/criticalstack/terraform-installer).

This project has adopted the [Capital One Open Source Code of conduct](https://developer.capitalone.com/resources/code-of-conduct). 