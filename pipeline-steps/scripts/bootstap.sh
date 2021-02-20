storageAccountName="bootstraphax"
storageAccountSku="Standard_LRS"
storageAccountKind="StorageV2"
keyVaultName="bootstrap-hax-kv"
keyVaultSku="Standard"
resourceGroup="bootstrap-hax-rg"
location="ukwest"
subscription="Microsoft Partner Network"

echo "Bootstrapping storage account"

# Resource Group

resourceGroupExist=$(az group list --query "[?name == '$resourceGroup'].name" -o tsv)

if [[ ! $resourceGroupExist ]]
then
    echo "Creating resource group $resourceGroup"
    az group create --name $resourceGroup --location $location
else
    echo "Resource group [$resourceGroup] in [$location] found"
fi

# Storage Account

storageAccountExist=$(az storage account list -g $resourceGroup --query "[?[*].name == $storageAccountName].name" -o tsv)

if [[ ! $storageAccountExist ]]
then
    echo "Creating storage account $storageAccountName"
    az storage account create --name $storageAccountName --resource-group $resourceGroup --sku $storageAccountSku --kind $storageAccountKind
else
    echo "Storage Account [$storageAccountName] in [$location] found"
fi

# Key Vault
keyVaultExist=$(az keyvault list -g $resourceGroup --query "[?name == '$keyVaultName'].name" -o tsv)

if [[ ! $keyVaultExist ]]
then
    echo "Creating Keyvault $keyVaultName"
    az keyvault create --name $keyVaultName --resource-group $resourceGroup --sku $keyVaultSku
else
    echo "Keyvault [$keyVaultName] in [$location] found"
fi
