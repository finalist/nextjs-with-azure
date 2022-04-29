#!/bin/bash
source ./bin/config.sh

### CHECKS ################################################################################################

# checks
if ! test -f "yarn.lock"; then
    echo "Expected yarn.lock, please execute yarn install first"
    exit 1
fi


### BUILD AND TAG #########################################################################################

echo ">> Build and tag image '$NAME'..."
docker build --pull --rm --tag $NAME .
docker tag $NAME $REGISTRY.azurecr.io/$IMAGE


### PUSH TO REGISTRY ######################################################################################

echo "Push image '$NAME' to registry..."
az acr login -n $REGISTRY
docker push $REGISTRY.azurecr.io/$IMAGE


echo "Done"