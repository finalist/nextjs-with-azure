#!/bin/bash
source ./bin/config.sh


### DEPLOY THE IMAGE ######################################################################################

echo ">>> Deploy image for web app"
az webapp config container set \
    --resource-group $RESOURCE_GROUP \
    --name $NAME \
    --docker-custom-image-name $REGISTRY.azurecr.io/$IMAGE \
    --docker-registry-server-url https://$REGISTRY.azurecr.io

echo "Done"