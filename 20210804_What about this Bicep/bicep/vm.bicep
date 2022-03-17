// vm.bicep
targetScope = 'resourceGroup'
 
param location string
param adminName string
param adminSSHKey string
param machineName string
param machineSize string
param networkName string
param networkSubnet string
param networkSG string
 
var networkNIC = '${machineName}-nic'
var networkSubnetID = resourceId('Microsoft.Network/virtualNetworks/subnets', networkName, networkSubnet)
var osConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminName}/.ssh/authorized_keys'
        keyData: adminSSHKey
      }
    ]
  }
}
 
resource networkSecurityGroupName 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSG
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-ssh'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
 
resource virtualNetworkName 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: networkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: networkSubnet
        properties: {
          addressPrefix: '10.0.3.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroupName.id
          }
        }
      }
    ]
  }
}
 
resource nicName 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: networkNIC
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: networkSubnetID
          }
        }
      }
    ]
  }
  dependsOn: [
    virtualNetworkName
  ]
}
 
resource vmName 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: machineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: machineSize
    }
    osProfile: {
      computerName: machineName
      adminUsername: adminName
      adminPassword: adminSSHKey
      linuxConfiguration: osConfiguration
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
  }
}
