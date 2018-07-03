. ../myCreds.secret.txt

az login
az account set --subscription $SUBSCRIPTIONID
appID=$(az ad sp create-for-rbac --name terraform --password $PASSWORD | jq ".appId" -r)
az role assignment create --assignee $appID --role Contributor --scope /subscriptions/${ARM_SUBSCRIPTION_ID}

echo "Client ID = ${appID}"
