### install Windows Admin Center
Invoke-WebRequest 'https://aka.ms/WACDownload' -OutFile "D:\AzureStackHCI\WindowsAdminCenter2110.msi"
C:\Windows\System32\msiexec.exe /i "D:\AzureStackHCI\WindowsAdminCenter2110.msi" /qn /L*v "D:\AzureStackHCI\WindowsAdminCenter2110.log" SME_PORT=443 SSL_CERTIFICATE_OPTION=generate
