#!/bin/bash

# Setting up Terraform remote backend in Azure

RESOURCE_GROUP="rg-terraform-state"
STORAGE_ACCOUNT_NAME="stgtfstate25032025"
CONTAINER_NAME="tfstate"
LOCATION="norwayeast"

echo "Starting Terraform backend storage setup."

echo "Creating Resource Group: $RESOURCE_GROUP."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Creating Storage Account: $STORAGE_ACCOUNT_NAME."
az storage account create \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku Standard_LRS \
    --encryption-services blob

echo "Retrieving Storage Account Key."
ACCOUNT_KEY=$(az storage account keys list \
    --resource-group $RESOURCE_GROUP \
    --account-name $STORAGE_ACCOUNT_NAME \
    --query '[0].value' --output tsv)

echo "Creating Storage Container: $CONTAINER_NAME."
az storage container create --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --account-key $ACCOUNT_KEY

echo "Terraform backend storage setup is completed."
echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo "Container Name: $CONTAINER_NAME"
