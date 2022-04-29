
while getopts n: flag
do
    case "${flag}" in
        n) NAME=${OPTARG};;
    esac
done

if [ -z ${NAME+x} ];
    then 
        echo "Usage: -n <name>"
        exit 1
fi

IMAGE=$NAME:latest
RESOURCE_GROUP=<your-resource-group>
REGISTRY=<your-registry>
PLAN=$NAME-asp
SKU=B1

SUBSCRIPTION=$(az account show --query id --output tsv)
echo "Using subscription: $(az account show --query name --output tsv)"