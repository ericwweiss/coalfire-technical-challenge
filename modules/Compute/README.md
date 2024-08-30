# Compute Module
Compute module to deploy 1 instance in public subnet2 and an autoscaling group in private subnet4 along with security groups and routing components. 

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
| <a name="vpc_id"></a> [vpc_id](#output\_vpc_id) | The ID of the VPC you are deploying resources to |
| <a name="security_group_id"></a> [security_group_id](#output\_security_group_id) | The ID of the VPC security group created in `/modules/Networking` |
| <a name="key_name"></a> [region](#output\_key_name) | Name of Key Pair to connect to public instance. This assumes you have provisioned one through the console and have obtained the private key |
| <a name="public_subnet_id_list"></a> [public_subnet_id_list](#output\_public_subnet_id_list) | List of IDs for public subnets|
| <a name="private_subnet_id_list"></a> [private_subnet_id_list](#output\_private_subnet_id_list) | List of IDs for private subnets|
| <a name="region"></a> [region](#output\_region) | Desired Region applied to the provider, defaults to `us-east-2` |
| <a name="availability_zone"></a> [availability_zone](#output\_availability_zone) | Target AZ , defaults to `us-east-2b` |
| <a name="instance_ami"></a> [instance_ami](#output\_instance_ami) | AMI you wish to utilize , defaults to Redhat `"ami-0ba62214afa52bec7"`. You can edit the data query within the module to retrieve the latest version of your desired image |
| <a name="ebs_storage"></a> [ebs_storage](#output\_ebs_storage) | Desired storage capacity in GB , defaults to `20` |
| <a name="instance_type"></a> [instance_type](#output\_instance_type) | Desired instance type , defaults to `t2.micro` |
| <a name="environment"></a> [environment](#output\_environment) | Name of your environment for tagging |


## Outputs

| Name | Description |
|------|-------------|
| <a name="ec2instance_ip"></a> [ec2instance_ip](#output\_ec2instance_ip) | The Public IP of your ec2 instance in your public subnet |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://www.terraform.io/downloads.html) | >= 1.9.5 |
| <a name="requirement_aws"></a> [aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 3.63 |