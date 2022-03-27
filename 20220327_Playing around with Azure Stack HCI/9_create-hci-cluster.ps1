### create Azure Stack HCI cluster
# prepare and clean disks
$servers = "AZS1", "AZS2"
$cluster = "AzSCluster"
$clusterIp = "192.168.111.50/24"

Invoke-Command ($servers) {
    Update-StorageProviderCache
    Get-StoragePool | Where-Object { $_.IsPrimordial -eq $false } | Set-StoragePool -IsReadOnly:$false -ErrorAction SilentlyContinue
    Get-StoragePool | Where-Object { $_.IsPrimordial -eq $false } | Get-VirtualDisk | Remove-VirtualDisk -Confirm:$false -ErrorAction SilentlyContinue
    Get-StoragePool | Where-Object { $_.IsPrimordial -eq $false } | Remove-StoragePool -Confirm:$false -ErrorAction SilentlyContinue
    Get-PhysicalDisk | Reset-PhysicalDisk -ErrorAction SilentlyContinue
    Get-Disk | Where-Object { $_.Number -ne $null } | Where-Object { $_.IsBoot -ne $true } | Where-Object { $_.IsSystem -ne $true } | Where-Object { $_.PartitionStyle -ne "RAW" } | ForEach-Object {
        $_ | Set-Disk -IsOffline:$false
        $_ | Set-Disk -IsReadOnly:$false
        $_ | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false
        $_ | Set-Disk -IsReadOnly:$true
        $_ | Set-Disk -IsOffline:$true
    }
    Get-Disk | Where-Object { $_.Number -ne $Null } | Where-Object { $_.IsBoot -ne $True } | Where-Object { $_.IsSystem -ne $True } | Where-Object { $_.PartitionStyle -eq "RAW" } | Group-Object -NoElement -Property "FriendlyName"
} | Sort-Object -Property "PsComputerName", "Count"
# Count Name                      PSComputerName
# ----- ----                      --------------
#     4 Msft Virtual Disk         AZS1
#     4 Msft Virtual Disk         AZS2

# check if cluster can be created
Test-Cluster -Node $servers -Include "Storage Spaces Direct", "Inventory", "Network", "System Configuration"

# create cluster
New-Cluster -Name $cluster -Node $servers -StaticAddress $clusterIp -NoStorage

# check cluster
Get-Cluster -Name $cluster | Get-ClusterResource
# Name                        State  OwnerGroup    ResourceType
# ----                        -----  ----------    ------------
# Cluster IP Address          Online Cluster Group IP Address
# Cluster Name                Online Cluster Group Network Name
# Virtual Machine Cluster WMI Online Cluster Group Virtual Machine Cluster WMI

# set cluster quorum (file share witness)
Set-ClusterQuorum -Cluster $cluster -FileShareWitness "\\DOM1.lab.tklabs.eu\Witness_AZSCluster$"
# Cluster              QuorumResource
# -------              --------------
# AzSCluster           File Share Witness

Get-Cluster -Name $cluster | Get-ClusterResource
# Name                        State  OwnerGroup    ResourceType
# ----                        -----  ----------    ------------
# Cluster IP Address          Online Cluster Group IP Address
# Cluster Name                Online Cluster Group Network Name
# File Share Witness          Online Cluster Group File Share Witness
# Virtual Machine Cluster WMI Online Cluster Group Virtual Machine Cluster WMI
