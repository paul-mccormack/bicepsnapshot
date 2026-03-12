metadata templateInfo = {
  author: 'Paul McCormack'
  email: 'https://www.linkedin.com/in/paul-mccormack-08b04a6/'
  description: 'Bicep template to deploy a Storage Account with Private Endpoint for AVD'
  version: '1.0.0'
  date: '07-01-2026'
}

//
// Parameters
//

@description('Required: Prefix for the Storage Account to be created')
param storageAccountPrefix string

@description('Storage Sku')
param sku string

@description('Optional: Location for all resources. Default is the location of the resource group using resourceGroup().location function.  Override by specifiying a location parameter at deployment time or in a parameter file.')
param location string

@description('Required: Vnet name for private endpoint')
param vnetName string

@description('Required: Subnet name for private endpoint')
param subnetName string

@description('Required: Resource Group containing the vnet for the private endpoint')
param vnetResourceGroup string

@description('Required: Tags to be applied to all resources.  Minimum required tags are "Service", "Cost Centre" and "Created by".')
param resourceTags object

//
// Variables
//

// Generate unique storage account name (max 24 chars, lowercase, valid for Azure)
var StorageAccountName = take(toLower('${storageAccountPrefix}${uniqueString(resourceGroup().id)}'), 24)

//
// Existing Resources
//

@description('Exiting resource declaration for the vnet.')
resource vnet 'Microsoft.Network/virtualNetworks@2025-01-01' existing = {
  scope: resourceGroup(vnetResourceGroup)
  name: vnetName
}

@description('Exiting resource declaration for the subnet.')
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2025-01-01' existing = {
  parent: vnet
  name: subnetName
}

//
// Resources
//

@description('Storage Account for AVD FSLogix profiles.')
resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: StorageAccountName
  location: location
  tags: resourceTags
  sku: {
    name: sku
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    publicNetworkAccess: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    accessTier: 'Hot'
  }
}

@description('Blob Service with soft delete and container delete retention policies enabled.')
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
   containerDeleteRetentionPolicy: {
     enabled: true
     days: 7
    }
   deleteRetentionPolicy: {
     allowPermanentDelete: false
     enabled: true
     days: 7
    }
  }
}

@description('Private Endpoint for AVD FSLogix Storage Account.')
resource privateEndpointAVD 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${StorageAccountName}-pe'
  location: location
  tags: resourceTags
  properties:{
    subnet: {
      id: subnet.id  // Using existing subnet resource
    }
    privateLinkServiceConnections: [
    {
      name: '${StorageAccountName}-blobpe-conn'
      properties: {
        privateLinkServiceId: storageAccount.id
        groupIds:[
          'blob'
        ]
        privateLinkServiceConnectionState: {
          status: 'Approved'
          actionsRequired: 'None'
        }
      }
    }
    ]
  }
}
