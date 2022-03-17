### deploys bicep templates with Azure PowerShell

New-AzDeployment -TemplateFile ".\main.bicep" -DeploymentName "vm-example" -Location "West Europe"
