provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "mlops-az"
  location = "australiaeast"
}



locals {
  clustername = "mlops-az-aks"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.clustername
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = local.clustername
  kubernetes_version  = "1.21.7"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D4s_v3"
    node_labels = {
        type: "default"
    }
  }

  
  
  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Testing"
  }
}


/*
resource "azurerm_kubernetes_cluster_node_pool" "pool1" {
  name                  = "gpu"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v3"
  node_count            = 1
  min_count             = 1
  max_count             = 2
  enable_auto_scaling   = true
  

  node_labels = {
    type: "gpu_vms"
  }
  
  
  tags = {
    Environment = "Testing"
  }
}*/