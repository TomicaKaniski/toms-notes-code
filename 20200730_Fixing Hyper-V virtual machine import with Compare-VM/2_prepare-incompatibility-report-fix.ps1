### finding out what's wrong and repairing it

# create an incompatibility report for a virtual machine
$report = Compare-VM -Path 'D:\VMs\azshci\azshci1\Virtual Machines\5381F80D-C752-42E0-AE26-6402B019B785.vmcx'
 
# check the created report as some incompatibilities were found
$report
# VM                 : VirtualMachine (Name = 'azshci1') [Id = '5381F80D-C752-42E0-AE26-6402B019B785']
# OperationType      : ImportVirtualMachine
# ...
# Incompatibilities  : {40010, 40010, 40010, 40010}
# ...
 
# check what exactly is incompatible (VHD locations, in this case)
$report.Incompatibilities.Source | Format-Table
# VMName  ControllerType ControllerNumber ControllerLocation DiskNumber Path
# ------  -------------- ---------------- ------------------ ---------- ----
# azshci1 SCSI           0                0                             C:\VMs\azshci\azshci1\azshci1_0_0.vhdx
# azshci1 SCSI           1                0                             C:\VMs\azshci\azshci1\azshci1_1_0.vhdx
# azshci1 SCSI           1                1                             C:\VMs\azshci\azshci1\azshci1_1_1.vhdx
# azshci1 SCSI           1                2                             C:\VMs\azshci\azshci1\azshci1_1_2.vhdx
 
# fixing the VHD locations (by replacing C: with D: for all VHDs)
$report.Incompatibilities[0].Source | Set-VMHardDiskDrive -Path 'D:\VMs\azshci\azshci1\azshci1_0_0.vhdx'
$report.Incompatibilities[1].Source | Set-VMHardDiskDrive -Path 'D:\VMs\azshci\azshci1\azshci1_1_0.vhdx'
$report.Incompatibilities[2].Source | Set-VMHardDiskDrive -Path 'D:\VMs\azshci\azshci1\azshci1_1_1.vhdx'
$report.Incompatibilities[3].Source | Set-VMHardDiskDrive -Path 'D:\VMs\azshci\azshci1\azshci1_1_2.vhdx'
 
# recheck if all looks fine
$report.Incompatibilities.Source | Format-Table
# VMName  ControllerType ControllerNumber ControllerLocation DiskNumber Path
# ------  -------------- ---------------- ------------------ ---------- ----
# azshci1 SCSI           0                0                             D:\VMs\azshci\azshci1\azshci1_0_0.vhdx
# azshci1 SCSI           1                0                             D:\VMs\azshci\azshci1\azshci1_1_0.vhdx
# azshci1 SCSI           1                1                             D:\VMs\azshci\azshci1\azshci1_1_1.vhdx
# azshci1 SCSI           1                2                             D:\VMs\azshci\azshci1\azshci1_1_2.vhdx
 
# import the fixed virtual machine (success!)
Import-VM -CompatibilityReport $report
# Name    State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
# ----    ----- ----------- ----------------- ------   ------             -------
# azshci1 Off   0           0                 00:00:00 Operating normally 9.0
