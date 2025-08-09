# Example configuration demonstrating Ubuntu2204 support in AKS

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-aks-ubuntu2204-example"
  location = "East US"
}

# AKS cluster with Ubuntu2204 default node pool
resource "azurerm_kubernetes_cluster" "example" {
  name                = "aks-ubuntu2204-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "aksexample"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2s_v3"
    os_sku     = "Ubuntu2204"  # Ubuntu 22.04 LTS
    
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "example"
    OS          = "Ubuntu2204"
  }
}

# Additional node pool with Ubuntu2204
resource "azurerm_kubernetes_cluster_node_pool" "ubuntu2204_pool" {
  name                  = "ubuntu2204pool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  vm_size               = "Standard_D2s_v3"
  node_count            = 1
  os_sku                = "Ubuntu2204"  # Ubuntu 22.04 LTS

  tags = {
    Environment = "example"
    OS          = "Ubuntu2204"
  }
}

# Example showing migration from Ubuntu to Ubuntu2204
resource "azurerm_kubernetes_cluster_node_pool" "migration_example" {
  name                  = "migrationpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  vm_size               = "Standard_D2s_v3"
  node_count            = 1
  
  # This can be changed from "Ubuntu" to "Ubuntu2204" without recreating the resource
  os_sku = "Ubuntu2204"

  tags = {
    Environment = "example"
    Purpose     = "migration-demo"
  }
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.example.name
}

output "cluster_endpoint" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.host
}

output "default_node_pool_os_sku" {
  value = azurerm_kubernetes_cluster.example.default_node_pool.0.os_sku
}