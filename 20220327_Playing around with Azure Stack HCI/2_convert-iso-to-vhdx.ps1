### check what's in the Azure Stack HCI ISO file
dism /Get-WimInfo /WimFile:E:\sources\install.wim
# Deployment Image Servicing and Management tool
# Version: 10.0.20348.1

# Details for image : E:\sources\install.wim

# Index : 1
# Name : Azure Stack HCI
# Description : This option installs Azure Stack HCI.
# Size : 7.996.171.122 bytes

# The operation completed successfully.

### convert ISO to VHDX
# https://github.com/x0nn/Convert-WindowsImage
$iso = "D:\AzureStackHCI\AzureStackHCI_20348.288_en-us.iso"
$vhd = "D:\AzureStackHCI\AzureStackHCI_20348.288_en-us.vhdx"
Convert-WindowsImage -SourcePath $iso -VHDFormat "VHDX" -Edition "Azure Stack HCI" -SizeBytes 200GB -DiskLayout "UEFI" -VHDPath $vhd
