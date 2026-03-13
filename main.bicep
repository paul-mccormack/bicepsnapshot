metadata templateInfo = {
  author: 'Paul McCormack'
  email: 'https://www.linkedin.com/in/paul-mccormack-08b04a6/'
  description: 'Bicep template to deploy Storage Accounts with Private Endpoints for AVD.'
  version: '1.0.0'
  date: '12-01-2026'
}

// Comment to make a change and test the deployment workflow

targetScope = 'subscription'

//
// User Defined Types
//

@description('Type definition for Storage Account and Service Group')
type saConfigType = {
  @description('Required: Storage Account Name.  Minimum 3 and maximum 12 characters in length.  Can contain only lowercase letters and numbers.')
  @minLength(3)
  @maxLength(12)
  saPrefix: string

  @description('Required: Service Group for tagging purposes. This will be merged into the "commonTags" object at deployment time.')
  serviceGroupTag: string

  @description('Storage Sku')
  sku: 'PremiumV2_LRS' | 'PremiumV2_ZRS' | 'Premium_LRS' | 'Premium_ZRS' | 'StandardV2_GRS' | 'StandardV2_GZRS' | 'StandardV2_LRS' | 'StandardV2_ZRS' | 'Standard_GRS' | 'Standard_GZRS' | 'Standard_LRS' | 'Standard_RAGRS' | 'Standard_RAGZRS' | 'Standard_ZRS'
}

//
// Parameters
//

@description('Required: Array of Storage Accounts names and their associated Service Groups')
param saConfig saConfigType[]

@description('Optional: Location for all resources. Default is UK South. Override by specifiying a location parameter at deployment time or in a parameter file.')
param location string = 'uksouth'

@description('Required: Vnet name for private endpoint')
param vnetName string

@description('Required: Vnet IP prefix in CIDR format')
param vnetIpPrefix string

@description('Required: Subnet name for private endpoint')
param subnetName string

@description('Required: Subnet IP prefix in CIDR format')
param subnetIpPrefix string

@description('Required: Resource Group containing the vnet for storage private endpoints')
param vnetResourceGroupName string

@description('Storage Resource Group Name.')
param storageResourceGroupName string

@description('Common tags to be applied to all resources.  Minimum required tags are "Service", "Cost Centre" and "Created by".')
param commonTags object

//
// Resources
//

@description('Resource Group for the virtual network and private endpoints')
resource networkRg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: vnetResourceGroupName
  location: location
}

@description('Resource Group for the storage accounts and associated resources')
resource storageRg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: storageResourceGroupName
  location: location
}

module network 'modules/networkResources.bicep' = {
  scope: networkRg
  params: {
    location: location
    tags: commonTags
    vnetIpPrefix: vnetIpPrefix
    vnetName: vnetName
    subnetName: subnetName
    subnetIpPrefix: subnetIpPrefix
  }
}

@description('Module deployment for Storage Accounts with Private Endpoints')
module storage './modules/storageResources.bicep' = [for sa in saConfig: {
  scope: storageRg
  name: '${sa.saPrefix}-deployment'
  params: {
    storageAccountPrefix: sa.saPrefix
    sku: sa.sku
    location: location
    vnetName: vnetName
    subnetName: subnetName
    vnetResourceGroup: vnetResourceGroupName
    resourceTags: union(commonTags, {
      'Service Group': sa.serviceGroupTag
    })
  }
}]

