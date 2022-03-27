### https://docs.microsoft.com/en-us/azure-stack/hci/deploy/register-with-azure
# prerequisites
Install-Module -Name "Az.StackHCI" -Force -Confirm:$false

# registration
Register-AzStackHCI -SubscriptionId "<your_Azure_subscription_ID>" -ResourceGroupName "AzureStackHCI"
# WARNING: To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code DW84XWSHV to authenticate.
# WARNING: We have migrated the API calls for this cmdlet from Azure Active Directory Graph to Microsoft Graph. Visit https://go.microsoft.com/fwlink/?linkid=2181475 for any permission issues.

# Result                          : Success
# AzurePortalResourceURL          : https://portal.azure.com/#@<some_resource_ID>/resource/subscriptions/<your_Azure_subscription_ID>/resourceGroups/AzureStackHCI/providers/Microsoft.AzureStackHCI/clusters/AzSCluster/overview
# AzureResourceId                 : /Subscriptions/<your_Azure_subscription_ID>/resourceGroups/AzureStackHCI/providers/Microsoft.AzureStackHCI/clusters/AzSCluster
# AzurePortalAADAppPermissionsURL : https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/CallAnAPI/appId/<some_App_ID>/isMSAApp/
# Details                         : Azure Stack HCI is successfully registered. An Azure resource representing Azure Stack HCI has been created in your Azure subscription to enable an Azure-consistent monitoring, billing, and support experience.
