### adds local network feeds to Windows Admin Center

# add new extension feed (network share)
Add-Feed -GatewayEndpoint "https://wac.tklabs.eu/" -Feed "\\<my_server_name>\WACExtensions"
 
# check if added successfully
Get-Feed -GatewayEndpoint "https://wac.tklabs.eu/"
### https://aka.ms/sme-extension-catalog-feed
### \\<my_server_name>\WACExtensions
