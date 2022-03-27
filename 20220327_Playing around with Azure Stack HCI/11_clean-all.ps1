### cleanup script
Get-VM "AZS*" | Stop-VM -TurnOff -Force
Remove-VM "AZS*" -Force
Remove-Item "D:\AzureStackHCI\VMs\AZS*" -Force -Recurse
