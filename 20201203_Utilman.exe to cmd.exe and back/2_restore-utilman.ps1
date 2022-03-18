### restores Utilman.exe which was previously replaced by cmd.exe

# replace the owner of Utilman.exe
$file = "C:\Windows\System32\Utilman.exe"
$user = New-Object System.Security.Principal.NtAccount("Administrator")
 
# remove fake Utilman.exe
Remove-Item -Path $file
 
# replace the owner of Utilman.exe.bak (we are now under a different user) 
$acl = Get-Acl -Path "$file.bak"
$acl.SetOwner($user)
$acl | Set-Acl -Path "$file.bak"
 
# add permissions
$acl = Get-Acl -Path "$file.bak"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($user,"Full","Allow")
$acl.SetAccessRule($rule)
$acl | Set-Acl -Path "$file.bak"
(Get-Acl -Path $file).Access | Format-Table IdentityReference,AccessControlType,FileSystemRights -AutoSize
 
# bring back the Utilman.exe
Move-Item -Path "$file.bak" -Destination "$file.exe"
