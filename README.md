# Terraform Azure Infrastructure

This repository contains Terraform configuration for provisioning Azure infrastructure including Virtual Networks, Subnets, Network Security Groups, and Storage Accounts across multiple environments (dev and prod).

## Project Structure

```
terraform/
├── backend.tf                 # Remote backend configuration (Azure RM)
├── providers.tf              # Azure provider configuration
├── versions.tf               # Terraform version requirements
├── .gitignore                # Git ignore rules
├── README.md                 # This file
├── environments/
│   ├── dev/                  # Development environment configuration
│   │   ├── main.tf          # Dev resource definitions
│   │   ├── variable.tf      # Dev input variables
│   │   └── dev.tfvars       # Dev variable values
│   └── prod/                 # Production environment configuration
│       ├── main.tf          # Prod resource definitions
│       ├── variable.tf      # Prod input variables
│       └── prod.tfvars      # Prod variable values
└── modules/                  # Reusable Terraform modules
    ├── resourcegroup/        # Azure Resource Group module
    ├── vnet/                 # Virtual Network and Subnet module
    ├── nsg/                  # Network Security Group module
    ├── nsg_association/      # NSG-Subnet association module
    └── storage_account/      # Storage Account and Container module
```

## Project Structure Rationale

This repository uses a **modular environment-based pattern**, which is ideal for:
- ✅ Lean teams (1-10 people)
- ✅ Clear environment isolation (dev, prod, etc.)
- ✅ Simple infrastructure with minimal shared resources
- ✅ Easy to understand and maintain

### Alternative Patterns

If your organization grows or requirements change, consider these patterns:

#### 1. **Global Resources + Environments** (Recommended for larger teams)
```
terraform/
├── global/                    # Shared infrastructure
│   ├── main.tf
│   ├── variables.tf
│   └── modules/
├── prod/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── staging/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
└── dev/
    ├── main.tf
    ├── variables.tf
    └── terraform.tfvars
```
**When to use:** Multiple teams, shared infrastructure (networks, DNS, etc.)

#### 2. **Terraform Workspaces** (For Terraform Cloud/Enterprise)
```
terraform/
├── main.tf
├── variables.tf
├── terraform.tfvars
└── modules/
```
**When to use:** Terraform Cloud/Enterprise subscription, centralized state management

#### 3. **Layered Architecture** (For complex infrastructure)
```
terraform/
├── 1-networking/
├── 2-compute/
├── 3-storage/
├── 4-security/
└── modules/
```
**When to use:** Clear infrastructure layers, cascading dependencies

#### 4. **Multi-Team Monorepo** (For large organizations)
```
terraform/
├── services/
│   ├── app-service/
│   │   ├── dev/
│   │   └── prod/
│   ├── database/
│   │   ├── dev/
│   │   └── prod/
│   └── networking/
│       ├── dev/
│       └── prod/
└── shared-modules/
```
**When to use:** 20+ engineers, multiple autonomous teams

### Migration Path

If you outgrow the current structure:
1. Create a `global/` folder for shared resources
2. Move shared modules and resources to global backend
3. Update environment configs to reference global outputs
4. Gradually refactor as needed

## Modules

### Resource Group Module
Creates an Azure Resource Group.

**Location:** `modules/resourcegroup/`

**Inputs:**
- `name` - Name of the resource group
- `location` - Azure region for the resource group

**Outputs:**
- `resource_group_id` - The ID of the created resource group
- `resource_group_name` - The name of the created resource group
- `location` - The location of the created resource group

### Virtual Network Module
Creates Virtual Networks, Subnets, and manages basic network configuration.

**Location:** `modules/vnet/`

**Inputs:**
- `vnet_name` - Name of the virtual network
- `location` - Azure region
- `resource_group_name` - Name of the resource group
- `address_space` - Address space(s) for the vnet (list)
- `subnets` - Map of subnets with their address prefixes
- `tags` - Tags for the vnet (optional)

**Outputs:**
- `vnet_id` - The ID of the virtual network
- `subnet_ids` - Map of subnet names to subnet IDs

### Network Security Group Module
Creates Azure Network Security Groups.

**Location:** `modules/nsg/`

**Inputs:**
- `name` - Name of the NSG
- `location` - Azure region
- `resource_group_name` - Name of the resource group
- `tags` - Tags for the NSG (optional)

**Outputs:**
- `nsg_id` - The ID of the created network security group

### NSG Association Module
Associates Network Security Groups with subnets.

**Location:** `modules/nsg_association/`

**Inputs:**
- `subnet_ids` - Map of subnet IDs to associate with the NSG
- `network_security_group_id` - ID of the NSG to associate

### Storage Account Module
Creates Azure Storage Accounts and Blob Containers for state storage or data.

**Location:** `modules/storage_account/`

**Inputs:**
- `name` - Storage account name
- `resource_group_name` - Name of the resource group
- `location` - Azure region
- `container_name` - Name of the blob container
- `tags` - Tags for the storage account (optional)

**Outputs:**
- `storage_account_name` - Name of the storage account
- `storage_container_name` - Name of the blob container
- `storage_account_primary_blob_endpoint` - Primary blob endpoint URL

## Environments

### Development Environment
**Configuration:** `environments/dev/`

- **VNet Address Space:** `10.0.0.0/16`
- **Subnet Address Prefix:** `10.0.1.0/24`
- **Storage Account:** `devstorageacct01`
- **Storage Container:** `devstate`

### Production Environment
**Configuration:** `environments/prod/`

- **VNet Address Space:** `172.16.0.0/16`
- **Subnet Address Prefix:** `172.16.1.0/24`
- **Storage Account:** `prodstorageacct01`
- **Storage Container:** `prodstate`

## Prerequisites

- Terraform >= 1.0.0
- Azure CLI authenticated with your Azure subscription
- Azure subscription with appropriate permissions
- (Optional) Remote backend storage account for state management

## Getting Started

### 1. Initialize Terraform

```bash
# For development environment
cd environments/dev
terraform init

# For production environment
cd environments/prod
terraform init
```

### 2. Plan Infrastructure

```bash
# View what will be created
terraform plan -var-file="dev.tfvars"  # for dev
terraform plan -var-file="prod.tfvars" # for prod
```

### 3. Apply Configuration

```bash
# Create resources
terraform apply -var-file="dev.tfvars"  # for dev
terraform apply -var-file="prod.tfvars" # for prod
```

### 4. Destroy Infrastructure

```bash
# Remove all resources
terraform destroy -var-file="dev.tfvars"  # for dev
terraform destroy -var-file="prod.tfvars" # for prod
```

## Input Variables

### Common Variables (all environments)
- `resource_group_name` - Name of the Azure Resource Group
- `location` - Azure region (e.g., "East US")
- `vnet_name` - Name of the Virtual Network
- `vnet_address_space` - Address space for the VNet (default varies by environment)
- `subnet_name` - Name of the subnet
- `subnet_address_prefix` - Subnet address prefix (default varies by environment)
- `storage_account_name` - Storage account name
- `storage_container_name` - Blob container name

See `environments/dev/variable.tf` or `environments/prod/variable.tf` for full variable definitions.

## Backend Configuration

Remote state is configured to use Azure Storage. Update `backend.tf` with your storage account details:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "<state-rg>"
    storage_account_name = "<stateaccountname>"
    container_name       = "<state-container>"
    key                  = "terraform.tfstate"
  }
}
```

## Workspace Management

### Environment Isolation Options

#### Option 1: Current Approach (Directory-based)
- Separate directories per environment
- Independent state files
- Different backends possible
- Best for: Small teams, maximum isolation

#### Option 2: Terraform Workspaces (Alternative)
```bash
# Create workspaces
terraform workspace new dev
terraform workspace new prod

# Switch workspaces
terraform workspace select dev
terraform apply -var-file="variables.tfvars"

# List workspaces
terraform workspace list
```
- Single configuration, multiple states
- Lightweight environment switching
- Best for: Terraform Cloud users

#### Option 3: Remote Backends with Named States (Advanced)
```hcl
# Use different keys in same backend
key = "env/${var.environment}/terraform.tfstate"
```

### Recommended: Current Directory-Based Approach

Sticking with separate directories (`environments/dev/`, `environments/prod/`) provides:
- **Clear isolation:** Each environment is completely independent
- **Independent backends:** Different state files/accounts if needed
- **Team clarity:** Easy to understand which directory to work in
- **Safety:** Reduces risk of accidental prod changes
- **Flexibility:** Can use different providers, versions per environment

## Security Notes

- Terraform state files contain sensitive information; store them securely
- Never commit `.tfvars` files with secrets to version control
- Use Azure Key Vault or environment variables for sensitive data
- Rotate storage account keys regularly
- Enable encryption for storage accounts

## Troubleshooting

### Terraform Lock Errors
```bash
# Remove lock file if stuck
rm .terraform.lock.hcl
terraform init
```

### Provider Issues
```bash
# Reinstall providers
terraform init -upgrade
```

### State Conflicts
```bash
# Check remote state
terraform state list
terraform state show <resource>
```

## Contributing

When making changes:
1. Test in dev environment first
2. Validate with `terraform plan`
3. Document changes in the PR description
4. Follow the existing module structure for new resources

## Architecture Decision Matrix

Choose your structure based on these factors:

| Factor | Current Pattern | Global Pattern | Workspaces | Layered | Multi-Team |
|--------|---|---|---|---|---|
| **Team Size** | 1-10 | 10-20 | 5-15 | 10-20 | 20+ |
| **State Complexity** | Simple | Medium | Medium | High | Very High |
| **Shared Resources** | Few | Many | Some | Some | Many |
| **Learning Curve** | Easy | Medium | Low | Hard | Very Hard |
| **Cost (State Files)** | Low | Medium | Low | Medium | High |
| **Environment Isolation** | Excellent | Good | Good | Medium | Medium |
| **Setup Time** | Hours | Days | Hours | Weeks | Weeks |
| **Scalability** | Poor | Good | Good | Medium | Excellent |

**Recommendation:** Start with current pattern. Upgrade to **Global Pattern** when:
- You have shared resources across environments
- Multiple teams need to manage different components
- State management becomes complex

## Quick Structure Upgrade Guide

To add a `global/` folder for shared resources:

```bash
# Create global structure
mkdir -p global/modules
touch global/{main.tf,variables.tf,outputs.tf}

# Create separate backend for global
touch global/backend.tf
```

Then reference global outputs in environments:
```hcl
# In environments/dev/main.tf
data "terraform_remote_state" "global" {
  backend = "azurerm"
  config = {
    # reference to global backend
  }
}
```

## Additional Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Terraform Best Practices](https://learn.microsoft.com/en-us/azure/developer/terraform/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Terraform Cloud Documentation](https://www.terraform.io/cloud-docs)
- [Hashicorp Recommended Structure](https://www.terraform.io/docs/language/modules/develop/structure.html)

## License

[Add your license here]

## Support

For issues or questions, please create an issue in the repository.