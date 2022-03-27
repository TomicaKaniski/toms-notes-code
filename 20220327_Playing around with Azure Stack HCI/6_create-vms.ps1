### create vms
$vms = "AZS1", "AZS2"
foreach ($vm in $vms) {
    # prepare paths
    $vmpath = "D:\AzureStackHCI\VMs"
    $vhd = "D:\AzureStackHCI\VMs\$vm\Virtual Hard Disks\$vm"
    $vhdt = "D:\AzureStackHCI\AzureStackHCI_20348.288_en-us.vhdx"

    # prepare folders
    New-Item -Name $vm -Type Directory -Path $vmpath -Force
    New-Item -Name "Virtual Machines" -Type Directory -Path "$vmpath\$vm" -Force
    New-Item -Name "Virtual Hard Disks" -Type Directory -Path "$vmpath\$vm" -Force
    
    # copy boot disk
    Copy-Item -Path $vhdt -Destination "$($vhd)_0.vhdx"

    # create vm
    New-VM -Name $vm -MemoryStartupBytes 64GB -VHDPath "$($vhd)_0.vhdx" -SwitchName Corporate -Generation 2 -Path $vmpath
    Set-VM -VMName $vm -AutomaticStartAction Nothing -AutomaticStopAction ShutDown -CheckpointType Standard
    Set-VMProcessor -VMName $vm -Count 16 -ExposeVirtualizationExtensions $true
    New-VHD -Path "$($vhd)_1.vhdx" -SizeBytes 480GB -Dynamic
    Add-VMHardDiskDrive -VMName $vm -Path "$($vhd)_1.vhdx"
    New-VHD -Path "$($vhd)_2.vhdx" -SizeBytes 480GB -Dynamic
    Add-VMHardDiskDrive -VMName $vm -Path "$($vhd)_2.vhdx"
    New-VHD -Path "$($vhd)_3.vhdx" -SizeBytes 480GB -Dynamic
    Add-VMHardDiskDrive -VMName $vm -Path "$($vhd)_3.vhdx"
    New-VHD -Path "$($vhd)_4.vhdx" -SizeBytes 480GB -Dynamic
    Add-VMHardDiskDrive -VMName $vm -Path "$($vhd)_4.vhdx"
    Rename-VMNetworkAdapter -VMName $vm -NewName "Corporate"
    Set-VMNetworkAdapter -VMName $vm -Name "Corporate" -DeviceNaming "On"
    Add-VMNetworkAdapter -VMName $vm -Name "Storage_1" -SwitchName "Storage_1" -DeviceNaming "On"
    Add-VMNetworkAdapter -VMName $vm -Name "Storage_2" -SwitchName "Storage_2" -DeviceNaming "On"
    Add-VMNetworkAdapter -VMName $vm -Name "VM" -SwitchName "Corporate" -DeviceNaming "On"
    Set-VMNetworkAdapter -VMName $vm -Name "VM" -MacAddressSpoofing "On"
    Set-VMFirmware -VMName $vm -BootOrder (Get-VMHardDiskDrive -VMName $vm -ControllerNumber 0 -ControllerLocation 0)
    Start-VM -VMName $vm
}
