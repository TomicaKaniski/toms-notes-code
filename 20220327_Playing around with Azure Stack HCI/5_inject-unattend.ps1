### inject Unattend.xml (into an offline VHDX image)
$vhd = "D:\AzureStackHCI\AzureStackHCI_20348.288_en-us.vhdx"
# mount image
$drive = (Mount-VHD -Path $vhd -PassThru | Get-Disk | Get-Partition | Get-Volume).DriveLetter
# inject Unattend.xml
Copy-Item -Path ".\Unattend.xml" -Destination "$(([string]$drive).Trim()):\"
# dismount image
Dismount-Vhd -Path $vhd
