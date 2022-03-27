### install Windows updates (into an offline VHDX image)
$vhd = "D:\AzureStackHCI\AzureStackHCI_20348.288_en-us.vhdx"
$packages = "D:\AzureStackHCI\Updates"
# mount image
$drive = (Mount-VHD -Path $vhd -PassThru | Get-Disk | Get-Partition | Get-Volume).DriveLetter
# install updates from folder
Add-WindowsPackage -Path "$(([string]$drive).Trim()):\" -PackagePath $packages -IgnoreCheck
# dismount image
Dismount-Vhd -Path $vhd
