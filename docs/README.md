# Financial institution company deployment and management terraform setup

## Code Structure Overview
The code is organized into modules for clear separation of responsibilities, making it easier to manage and scale over time.

1. Keyvault Module (keyvault)
This module is responsible for managing Azure Key Vault resources to securely store secrets, keys, and certificates.

It includes resources for creating the Key Vault and managing secrets within it.

2. Monitoring Module (monitoring)
This module configures Azure monitoring resources for log management and diagnostics.

It includes:

* Log Analytics Workspace for centralized log storage.
* Diagnostic Settings to capture and forward logs and metrics from Azure resources to the Log Analytics workspace.

3. Network Module (network)
This module manages network infrastructure, including:

* Virtual Network (VNet) and associated Subnets.
* Network Security Groups (NSGs) for controlling inbound and outbound traffic at the subnet level.
* Private Endpoint to securely connect to Azure resources like storage accounts.
* Azure Firewall with a dedicated subnet for network security.

4. Policy Module (policy)
This module defines and enforces a custom policy to restrict resource deployment to a specific region (norwayeast).

It includes:

* Policy Definition for the custom region restriction.
* Policy Assignment that attaches the policy to the subscription level (instead of a management group).

5. Security Module (security)
This module handles Azure Security Center configurations, such as:

* Security Center Subscription Pricing to enable specific pricing tiers for security services.
* Security Center Contact to configure contact information for alert notifications and security communications.

6. Environment Variables (environments/ folder)
The environment-specific configuration files are separated into directories like dev, staging, and prod.

This approach allows you to manage and deploy different resources or settings depending on the environment.

## Taskfile for Local Deployment Speed
The Taskfile is used to automate repetitive Terraform commands (e.g., terraform init, terraform plan, terraform apply), improving deployment speed from the localhost.

It streamlines the execution of Terraform tasks by defining commands in a simple YAML format.
