# script fixes permissions for a private key (PEM) file used to connect to EC2 instance
param (
    [Parameter(Mandatory)]
    [String] $file
)

$acl = Get-Acl -Path $file
$acl.SetAccessRuleProtection($true, $false) # disable inheritance, don't preserve existing rules
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($acl.Owner, "FullControl", "None", "None", "Allow") # allow only Full access for the file owner
$acl.SetAccessRule($rule)
Set-Acl -Path $file -AclObject $acl
