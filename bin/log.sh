#!/bin/bash
source ./bin/config.sh
az webapp log tail --name $NAME --resource-group $RESOURCE_GROUP
