# Coalfire Tech Challenge
Coalfire Tech Challenge Terraform Modules

## Usage
```
module "network_provision" {
  source   = ".//modules/Networking"
  vpc_cidr = "10.1.0.0/16"
}
```

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

This example may create resources that are outside of AWS Free Tier if left running. Run `Terraform Destroy` when you are finished 


## Resources Deployed
The following Terraform Modules aim to deploy a Highly Available Architecture suitable for development. 1 VPC,
4 Subnets (2 Private/2 Public), Redhat Instances to the Public Subnets, and an Autoscaling Group to the Private Subnets. 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://www.terraform.io/downloads.html) | >= 0.14.9 |
| <a name="requirement_aws"></a> [aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 3.63 |


## License
[MIT](https://choosealicense.com/licenses/mit/)
