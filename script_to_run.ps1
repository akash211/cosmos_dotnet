# First install latest powershell using below command
# winget install --id Microsoft.Powershell.Preview --source winget
# Install AzureRM using below command
# Import-Module -Name AzureRM

# To check version on Powershell
Write-Output $PSVersionTable.PSVersion

# Check if AzureRM is installed
Get-Module -Name AzureRM -ListAvailable | Write-Host -ForegroundColor Red

# Check and modify execution policy
Write-Output "Modifying Execution Policy for RemoteSigned and printing"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ExecutionPolicy -List | Write-Host -ForegroundColor Green

# To install Az Powershell ( -AllowClobber may not be required here)
# Install-Module -Name Az -Repository PSGallery -Force -AllowClobber

# Updating az module
Write-Output "Updating Az"
Update-Module -Name Az -Force
Write-Output "Az Updated"

# To login to Azure
Connect-AzAccount  | Write-Host -ForegroundColor Red
# This returns:
# Account            SubscriptionName TenantId                             Environment
# -------            ---------------- --------                             -----------
# akash211@gmail.com pay_subscription 979906ec-f50e-4d57-b9fd-0be4add3d129 AzureCloud

# Variable for resource group name
$RESOURCE_GROUP_NAME = "msdocs-cosmos-quickstart-rg"
$LOCATION = "West US"

# Variable for account name with a randomly generated suffix
$SUFFIX = Get-Random
$ACCOUNT_NAME = "msdocs-$SUFFIX"

$parameters = @{
    Name = $RESOURCE_GROUP_NAME
    Location = $LOCATION
}
New-AzResourceGroup @parameters | Write-Host -ForegroundColor Blue
# We get below result:
# ResourceGroupName : msdocs-cosmos-quickstart-rg
# Location          : westus
# ProvisioningState : Succeeded
# Tags              : 
# ResourceId        : /subscriptions/22df909b-26e6-4a40-adac-05e51cd2aabe/resourceGroups/msdocs-cosmos-quickstart-rg

$parameters = @{
    ResourceGroupName = $RESOURCE_GROUP_NAME
    Name = $ACCOUNT_NAME
    Location = $LOCATION
    EnableFreeTier = 0
}
New-AzCosmosDBAccount @parameters  | Write-Host -ForegroundColor Blue
# Here received this result:
# Capabilities                       : {}
# ConsistencyPolicy                  : Microsoft.Azure.Management.CosmosDB.Models.ConsistencyPolicy
# EnableAutomaticFailover            : False
# IsVirtualNetworkFilterEnabled      : False
# IpRules                            : {}
# DatabaseAccountOfferType           : Standard
# DocumentEndpoint                   : https://msdocs-285412314.documents.azure.com:443/
# ProvisioningState                  : Succeeded
# Kind                               : GlobalDocumentDB
# ConnectorOffer                     : 
# DisableKeyBasedMetadataWriteAccess : False
# PublicNetworkAccess                : Enabled
# KeyVaultKeyUri                     : 
# PrivateEndpointConnections         : 
# EnableFreeTier                     : False
# ApiProperties                      : Microsoft.Azure.Commands.CosmosDB.Models.PSApiProperties
# EnableAnalyticalStorage            : False
# EnablePartitionMerge               : False
# NetworkAclBypass                   : None
# NetworkAclBypassResourceIds        : {}
# InstanceId                         : 264dd636-b34f-4492-8a0f-d79ab2737684
# BackupPolicy                       : Microsoft.Azure.Commands.CosmosDB.Models.PSBackupPolicy
# RestoreParameters                  : Microsoft.Azure.Commands.CosmosDB.Models.PSRestoreParameters
# CreateMode                         : 
# AnalyticalStorageConfiguration     : Microsoft.Azure.Commands.CosmosDB.Models.PSAnalyticalStorageConfiguration

$parameters = @{
    ResourceGroupName = $RESOURCE_GROUP_NAME
    Name = $ACCOUNT_NAME
}
Get-AzCosmosDBAccount @parameters |
    Select-Object -Property "DocumentEndpoint"  | Write-Host -ForegroundColor Green
# Now result is below:
#     DocumentEndpoint
# ----------------
# https://msdocs-173608580.documents.azure.com:443/

$parameters = @{
    ResourceGroupName = $RESOURCE_GROUP_NAME
    Name = $ACCOUNT_NAME
    Type = "Keys"
}    
Get-AzCosmosDBAccountKey @parameters |
    Select-Object -Property "PrimaryMasterKey" | Write-Host -ForegroundColor Red
# Here is the result:
# PrimaryMasterKey
# ----------------
# u4HvMWqBY7yfetWjlnsbMF1c1yCxDX97RTTAxAFqFiBjfu4nh5PYjb5MhixOYd38kx7Plr4eLmw5ACDbgm9WpQ==

# custom role definition id - 7063662f-1228-4029-9e6a-c0b6da63c596
# my prinicpal email id - akash211_gmail.com#EXT#@akash211gmail.onmicrosoft.com
# principal id - 0c2f731e-6cc2-4bf4-9a74-37fd5c76a1ba
