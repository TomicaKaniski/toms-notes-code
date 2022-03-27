### install Azure Stack HCI cluster prerequisites
$vhd = "D:\AzureStackHCI\AzureStackHCI_20348.288_en-us.vhdx"
$roles = @(
    "BitLocker",
    "Data-Center-Bridging",
    "EnhancedStorage",
    "Failover-Clustering",
    "FS-FileServer",
    "FS-Data-Deduplication",
    "Hyper-V",
    "Hyper-V-PowerShell",
    "NetworkATC",
    "RSAT-AD-PowerShell",
    "RSAT-Clustering-PowerShell",
    "Storage-Replica"
)
Install-WindowsFeature -Vhd $vhd -Name $roles -IncludeAllSubFeature -IncludeManagementTools
