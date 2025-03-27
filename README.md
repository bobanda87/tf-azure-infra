# tf-azure-infra

## Setting up remote backend in Azure

1. Login to AZ cli

```bash
az login
```

2. Execute bootstrap script that generates setup in Azure for storing tf state file

```bash
./scripts/bootstrap.sh
```

## Terraform

We use terraform for infrastructure management. All environment-specific configurations are stored in `./terraform/environments/*.tfvars`. We use [tflint](https://github.com/terraform-linters/tflint) to lint our terraform code

### Usage

You can use [Taskfile](https://taskfile.dev/installation/) tasks to help work with terraform locally. For example:

```sh
ENV=dev task plan
```

Runs `terraform plan` with the environment specific variables in `./terraform/environments/dev.tfvars`

If the plan looks good, run:

```sh
ENV=dev task apply
```

to apply and test your changes in the development environment.
