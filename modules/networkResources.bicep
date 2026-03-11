metadata templateInfo = {
  author: 'Paul McCormack'
  email: 'https://www.linkedin.com/in/paul-mccormack-08b04a6/'
  description: 'Bicep template for deploying a vnet with subnets and private endpoints for storage accounts'
  date: '19-6-25'
  version: '1.0'
}

//
// Type Definitions
//

@description('Optional: Subnet Configuration')
type subnetConfigType = {
  @description('Required: Subnet name')
  name: string

  @description('Required: Subnet IP prefix in CIDR format')
  subnetAddressPrefix: string

  @description('Optional: Service endpoint name. e.g. Microsoft.Storage  See [VNET Service Endpoint docs](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview) for information')
  serviceEndpointName: string?

  @description('Optional: Delegate subnet to a service.  See [Az CLI docs](https://learn.microsoft.com/en-us/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-list-available-delegations) to list available delegations')
  delegation: string?
}[]?

//
// Parameters
//

@description('Resource Location')
param location string

@description('Required: Tags object. Minimum required by policy is "Created By", "Service" and "Cost Centre"')
param tags object

@description('Required: Vnet name')
param vnetName string

@description('Required: Vnet IP prefix in CIDR format')
param vnetIpPrefix string

@description('Required: Subnet name for private endpoint')
param subnetName string

@description('Required: Subnet IP prefix in CIDR format')
param subnetIpPrefix string

//
// Resources
//

@description('Deploy Vnet')
resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetIpPrefix
      ]
    }
    enableDdosProtection: false
    enableVmProtection: false
  }
}

@description('Deploy subnets')
resource subnets 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: subnetName
  parent: vnet
  properties: {
    addressPrefix: subnetIpPrefix
  }
}

//
// Outputs
//

output vnetId string = vnet.id
output subnetId string = subnets.id
