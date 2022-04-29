#!/bin/bash
source ./bin/config.sh
echo ">>> Provisioning $NAME..."
echo "- image: $IMAGE"
echo "- registry: $REGISTRY"
echo "- resource group: $RESOURCE_GROUP"
echo "- plan: $PLAN"
echo "- sku: $SKU"


### ENABLE ADMIN FOR ACR #################################################################################

echo ">>> Enable admin for ACR..."
az acr update -n $REGISTRY --admin-enabled true


### CREATE APP SERVICE ###################################################################################

# create app service plan
echo ">>> Create app service plan: '$PLAN'..."
az appservice plan create \
    --name $PLAN \
    --resource-group $RESOURCE_GROUP \
    --is-linux \
    --sku $SKU

# create the web app
echo ">>> Create web app: '$NAME'"
az webapp create \
    --resource-group $RESOURCE_GROUP \
    --plan $PLAN \
    --name $NAME \
    --deployment-container-image-name $REGISTRY.azurecr.io/$IMAGE

# configure app settings
echo ">>> Configure app settings..."
cat ./.env.local | while IFS= read -r line; do
    value=${line#*=}
    name=${line%%=*}
    echo "- setting: $name"
    az webapp config appsettings set \
        --resource-group $RESOURCE_GROUP \
        --name $NAME \
        --settings $name="$value"
done


## IDENTITY PERMISSIONS ###################################################################################

echo ">>> Enable system-assigned managed identity for web app"
PRINCIPAL=$(az webapp identity assign --resource-group $RESOURCE_GROUP --name $NAME --query principalId --output tsv)
echo "- principal: $PRINCIPAL"

echo ">>> Grant managed identity permission to access container registry"
az role assignment create \
    --assignee $PRINCIPAL \
    --scope /subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.ContainerRegistry/registries/$REGISTRY \
    --role "AcrPull"

echo ">>> Configure app to use managed identity to pull from Azure Container Registry"
az resource update \
    --ids /subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Web/sites/$NAME/config/web \
    --set properties.acrUseManagedIdentityCreds=True


### CONFIGURE LOGGING ######################################################################################

echo ">>> Turn on container logging"
az webapp log config \
    --name $NAME \
    --resource-group $RESOURCE_GROUP \
    --docker-container-logging filesystem


### THE END ################################################################################################

echo "Done"