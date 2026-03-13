using './main.bicep'

param saConfig = [
  {
    saPrefix: 'digital'
    sku: 'Standard_LRS'
    serviceGroupTag: 'IT'
  }
  {
    saPrefix: 'people'
    sku: 'Standard_GRS'
    serviceGroupTag: 'HR'
  }
  {
    saPrefix : 'marketing'
    sku: 'Standard_ZRS'
    serviceGroupTag: 'Marketing'
  }
  {
    saPrefix : 'finance'
    sku: 'Standard_LRS'
    serviceGroupTag: 'Finance'
  }
]

param location = 'uksouth'

param storageResourceGroupName = 'rg-uks-sandbox-snapshot-storage'

param vnetName = 'vnet-uks-storage'

param vnetIpPrefix = '10.0.0.0/24'

param subnetName = 'snet-uks-storage-pe'

param subnetIpPrefix = '10.0.0.0/26'

param vnetResourceGroupName = 'rg-uks-sandbox-snapshot-network'

param commonTags = {
  Service: 'Storage Private Endpoints'
  'Created By': 'Paul McCormack'
  'Cost Centre': 'test'
}
