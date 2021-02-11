$release = "1.1"
$Name = "vit-web"
$releasename = $Name+":"+$release
$dockerUser = "roanitopaes"
$tagName = $dockerUser+"/"+$releasename
docker build -t $releasename .
docker tag $releasename $tagName
docker push $tagName


$RESOURCE_GROUP = "rg-ae-aks-training"
$location = "westus"
$registry = "acraeakstraining"
$SERVER=$REGISTRY+".azurecr.io"
$AKS_NAME="k8scluster"+$NUMBER
#az group create -n $RESOURCE_GROUP -l $location 
#az acr create -n $REGISTRY -g $RESOURCE_GROUP --sku basic --admin-enabled true
az acr build --image $releasename --registry $REGISTRY .

az aks create -g $RESOURCE_GROUP -n $AKS_NAME --generate-ssh-keys
az aks install-cli

kubectl get nodes
kubectl get pods
kubectl get services

az aks get-credentials -g $RESOURCE_GROUP -n $AKS_NAME
az aks update -g $RESOURCE_GROUP -n $AKS_NAME --attach-acr $REGISTRY

kubectl apply -f vit-web.yaml --validate=false

az aks stop -n $AKS_NAME -g $RESOURCE_GROUP 