# First install latest powershell using below command
# winget install --id Microsoft.Powershell.Preview --source winget
# Install AzureRM using below command
# Import-Module -Name AzureRM

# To check version on Powershell
# Write-Output $PSVersionTable.PSVersion

# Check if AzureRM is installed
# Get-Module -Name AzureRM -ListAvailable | Write-Host -ForegroundColor Red

# Check and modify execution policy
# Write-Output "Modifying Execution Policy for RemoteSigned and printing"
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Get-ExecutionPolicy -List | Write-Host -ForegroundColor Green

# To install Az Powershell ( -AllowClobber may not be required here)
# Install-Module -Name Az -Repository PSGallery -Force -AllowClobber

# Updating az module
# Write-Output "Updating Az"
# Update-Module -Name Az -Force
# Write-Output "Az Updated"

# To login to Azure
Connect-AzAccount

# Variables
$RESOURCE_GROUP_NAME = "cosmos-420-rg"
$LOCATION = "West US"
$ACCOUNT_NAME = "cert-420"

# $parameters = @{
#     Name = $RESOURCE_GROUP_NAME
#     Location = $LOCATION
# }
# New-AzResourceGroup @parameters

$parameters = @{
    ResourceGroupName = $RESOURCE_GROUP_NAME
    Name              = $ACCOUNT_NAME
    Location          = $LOCATION
    EnableFreeTier    = 0
}
New-AzCosmosDBAccount @parameters

$parameters = @{
    ResourceGroupName = $RESOURCE_GROUP_NAME
    Name = $ACCOUNT_NAME
}
Get-AzCosmosDBAccount @parameters |
    Select-Object -Property "DocumentEndpoint"
# Now result is below:
#     DocumentEndpoint
# ----------------
# https://cert-420.documents.azure.com:443/

$parameters = @{
    ResourceGroupName = $RESOURCE_GROUP_NAME
    Name = $ACCOUNT_NAME
    Type = "Keys"
}    
Get-AzCosmosDBAccountKey @parameters |
   Select-Object -Property "PrimaryMasterKey" 


# custom role definition id - d44631fa-7e74-48ad-98ae-fd3b637aee01
# my prinicpal email id - akash211_gmail.com#EXT#@akash211gmail.onmicrosoft.com
# principal id - 0c2f731e-6cc2-4bf4-9a74-37fd5c76a1ba
