# Networking Module
Networking module to deploy VPC and necessary components. Deploys 1 VPC and 4 subnets spread across two Availability zones. 

## Usage
To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Inputs

| Name | Description |
|------|-------------|
| <a name="vpc_cidr"></a> [vpc_cidr](#output\_vpc_cidr) | The CIDR range for the VPC you are deploying |
| <a name="azs"></a> [azd](#output\_azs) | List of availability zones, defaults to `["us-east-2a" , "us-east-2b"]` |
| <a name="public_subnets"></a> [public_subnets](#output\_public_subnets) | List of CIDR ranges for public subnets, defaults to `["10.1.0.0/24" , "10.1.1.0/24"]`|
| <a name="private_subnets"></a> [private_subnets](#output\_private_subnets) | List of CIDR ranges for private subnets, defaults to `["10.1.2.0/24" , "10.1.3.0/24"]`
| <a name="region"></a> [region](#output\_region) | Desired Region applied to the provider, defaults to `us-east-2` |
| <a name="environment"></a> [environment](#output\_environment) | Name of your environment for tagging |


## Outputs

| Name | Description |
|------|-------------|
| <a name="vpc_id"></a> [vpc_id](#output\_vpc_cidr) | The ID of the VPC created |
| <a name="public_subnet_id_list"></a> [public_subnet_id_list](#output\_public_subnet_id_list) | List of subnet IDs for the public subnets `["<subnet1_id>", "<subnet2_id>"]`
| <a name="private_subnet_id_list"></a> [private_subnet_id_list](#output\_private_subnet_id_list) | List of subnet IDs for the private subnets `["<subnet3_id>", "<subnet4_id>"]`
| <a name="security_group_id"></a> [security_group_id](#output\_security_group_id) | ID of main VPC security group

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://www.terraform.io/downloads.html) | >= 1.9.5 |
| <a name="requirement_aws"></a> [aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 3.63 |
