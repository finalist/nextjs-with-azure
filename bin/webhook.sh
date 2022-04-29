#!/bin/bash
source ./bin/config.sh

### CONFIGURE CONTINUOUS DEPLOYMENT ########################################################################

echo ">>> Enable CI/CD"
CI_CD_URL=$(az webapp deployment container config --enable-cd true --name $NAME --resource-group $RESOURCE_GROUP --query CI_CD_URL --output tsv)
echo "- CI/CD url: ${CI_CD_URL}"
WEBHOOK=${NAME//-}CD
echo "- webhook: $WEBHOOK"

echo ">>> Create webhook in container registry"
az acr webhook create \
    --name $WEBHOOK \
    --registry $REGISTRY \
    --uri $CI_CD_URL \
    --actions push \
    --scope $IMAGE

echo "Done"