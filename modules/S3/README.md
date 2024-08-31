# S3 Module
Simple S3 Module to provision a bucket with two folders `images` and `logs`. 
The `images` folder will be transitioned to the Glacier Storage Class after 90 days.
The `logs` folder will be deleted after 90 days.

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
| <a name="bucket_name"></a> [bucket_name](#output\_bucket_name) | The desired bucket name. Must be unique globally |
| <a name="acl"></a> [acl](#output\_acl) | The canned ACL to apply. Defaults to `private` |
| <a name="region"></a> [region](#output\_region) | Desired Region applied to the provider, defaults to `us-east-2` |
| <a name="environment"></a> [environment](#output\_environment) | Name of your environment for tagging |

## Outputs

No outputs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://www.terraform.io/downloads.html) | >= 1.9.5 |
| <a name="requirement_aws"></a> [aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 5.65.0 |

