### adds local network feeds to Windows Admin Center

# import the WAC Extensions PowerShell module
Import-Module "C:\Program Files\Windows Admin Center\PowerShell\Modules\ExtensionTools"
 
# list current feeds
Get-Feed -GatewayEndpoint "https://wac.tklabs.eu/"
### https://aka.ms/sme-extension-catalog-feed
 
# add new extension feed (network share)
Add-Feed -GatewayEndpoint "https://wac.tklabs.eu/" -Feed "\\<my_server_name>\WACExtensions"
 
# check if added successfully
Get-Feed -GatewayEndpoint "https://wac.tklabs.eu/"
### https://aka.ms/sme-extension-catalog-feed
