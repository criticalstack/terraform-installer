# aws

## Dependencies

 * Terraform >= 0.12
 * Go >= 1.12
 * kubectl

## Getting started

Before getting started make sure that access to AWS is setup either via something like `~/.aws/credentials` or by having the required environment variables set: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SECRET_TOKEN` (if it applies).

> A NOTE ON S3: the S3 policy as written will only allow access to the current (local) user, and the IAM roles created for the cluster. This may mean that you cannot interact with the bucket via the AWS Console.  
> If you would like to modify the S3 accesses, you may add to [them here.](https://github.com/criticalstack/terraform-installer/blob/main/aws/main.tf#L92-L94)


First, a configuration file is necessary for [Terraform](https://www.terraform.io/docs/index.html) to deploy a Kubernete cluster using crit. The [tfconfig](https://github.com/criticalstack/crit/tree/master/hack/tools/tfconfig) tool will be used to help generate the required `terraform.tfvars` file and it should be built automatically by the Makefile target (so long as Go is setup and configured correctly). The first time running either of the Makefile targets that run terraform, tfconfig will detect that there is no configuration file and will provide interactive prompts to create the new `terraform.tfvar` file. The aws credentials are crucial to have before this step as tfconfig helps to contextualize the setup using calls into the target account (currently to discover the available VPCs).

Creating a brand new cluster should be as easy as running:

```bash
make apply
```

This will deploy the nodes as set in the configuration and will wait for the controlplane to become available. Once it is available it will download the admin kubeconfig and set it as your current context. If everything worked then you should be able to run kubectl commands:

```bash
kubectl cluster-info
```

*Note: If needing to make changes to existing infrastructure, such as changing the size of the control plane or worker pool, simply run `make apply` again to refresh the deployment.*

### SSH access
If a suitable SSH keypair is not detected in your `$HOME/.ssh`, one will be generated during deployment. 

It is written out in the terraform.tfstate; you can extract the private key with jq:
```
$ cat terraform.tfstate | jq -r '.resources[] | select(.type | contains("tls_private_key")) | .instances[0].attributes.private_key_pem' 
```

redirect that in to a file (`[...] > id_rsa`) and log in by telling ssh to use that key as:
```
$ ssh -i id_rsa ubuntu@x.x.x.x
```