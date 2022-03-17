// main.bicep
targetScope = 'subscription'
 
param resourceGroupName string = 'Gym'
param location string = 'westeurope'
 
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}
 
module vm 'vm.bicep' = {
  name: 'vm-module'
  scope: rg
  params: {
    location: location
    adminName: 'tomica'
    adminSSHKey: 'ssh-rsa <SOME SSH PUBLIC KEY>'
    machineName: 'tkVM'
    machineSize: 'Standard_A1_v2'
    networkName: 'tkNet'
    networkSubnet: 'default'
    networkSG: 'tkNetSG'
  }
}
