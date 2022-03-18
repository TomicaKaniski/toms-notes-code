### try to import the moved VM files

Import-VM -Path 'D:\VMs\azshci\azshci1\Virtual Machines\5381F80D-C752-42E0-AE26-6402B019B785.vmcx'
# Import-VM : Unable to import virtual machine due to configuration errors.  Please use Compare-VM to repair the virtual machine.
# At line:1 char:1
# + Import-VM -Path 'D:\VMs\azshci\azshci1\Virtual Machines\5381F80D-C752-42E0-AE26-6402B019B785.vmcx'
# + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : InvalidOperation: (:) [Import-VM], VirtualizationException
#     + FullyQualifiedErrorId : OperationFailed,Microsoft.HyperV.PowerShell.Commands.ImportVM
