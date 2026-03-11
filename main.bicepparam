using './main.bicep'

param saConfig = [
  {
    saPrefix: 'digital'
    serviceGroupTag: 'IT'
  }
  {
    saPrefix: 'people'
    serviceGroupTag: 'HR'
  }
  {
    saPrefix : 'marketing'
    serviceGroupTag: 'Marketing'
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
