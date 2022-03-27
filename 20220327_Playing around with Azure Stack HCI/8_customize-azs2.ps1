### customize AZS2
# set networking
$localAdmin = Get-Credential -UserName "AZSx\Administrator" -Message "Enter password for the local Administrator account:"
Enter-PSSession -VMName "AZS2" -Credential $localAdmin

# rename network adapters per Hyper-V adapter name
$adapters = "Corporate", "Storage_1", "Storage_2", "VM"
foreach ($adapter in $adapters) {
    Get-NetAdapterAdvancedProperty -RegistryKeyword HyperVNetworkAdapterName | Where-Object { $_.DisplayValue -eq $adapter } | Rename-NetAdapter -NewName $adapter
}

# set IP addresses (AZS2)
$ia = "Corporate"
New-NetIPAddress -InterfaceAlias $ia -IPAddress "192.168.111.52" -PrefixLength "24" -DefaultGateway "192.168.111.1"
Set-DnsClientServerAddress -InterfaceAlias $ia -ServerAddresses "192.168.111.5"
Set-DnsClient -InterfaceAlias $ia -ConnectionSpecificSuffix "lab.tklabs.eu"
Set-NetIPInterface -InterfaceAlias $ia -InterfaceMetric 1

# test if it works
$dc = Resolve-DnsName "DOM1"
Test-NetConnection $dc.IPAddress

# set other IP addresses (AZS2)
$ia = "Storage_1"
New-NetIPAddress -InterfaceAlias $ia -IPAddress "10.111.111.2" -PrefixLength "30"
Set-DnsClient -InterfaceAlias $ia -RegisterThisConnectionsAddress $false
$ia = "Storage_2"
New-NetIPAddress -InterfaceAlias $ia -IPAddress "10.111.112.2" -PrefixLength "30"
Set-DnsClient -InterfaceAlias $ia -RegisterThisConnectionsAddress $false
$ia = "VM"
New-NetIPAddress -InterfaceAlias $ia -IPAddress "10.111.113.2" -PrefixLength "30"
Set-DnsClient -InterfaceAlias $ia -RegisterThisConnectionsAddress $false

# enable RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Power Options - High Performance
(Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan -Filter "ElementName = 'High Performance'").Activate()

# Rename C:
Set-Volume -DriveLetter "C" -NewFileSystemLabel "OSDisk"

# timezone
Set-Timezone "Central European Standard Time"

# Windows Update PowerShell module
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module PSWindowsUpdate

# domain join
Add-Computer -DomainName "lab.tklabs.eu" -Credential "LAB\Administrator" -NewName "AZS2" -Restart -Force

## additional settings
$domainadmin = Get-Credential -UserName "LAB\Administrator" -Message "Enter password for the domain Administrator account:"
Enter-PSSession -VMName "AZS2" -Credential $domainadmin

# disable SConfig on login
Set-SConfig -AutoLaunch $false

# Windows Update
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Verbose
