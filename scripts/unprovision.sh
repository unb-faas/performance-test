#/bin/bash
PROVIDERS="aws"
FAAS="get post delete"
echo "Checking requirements..."
if ! command -v terraform &> /dev/null
then
    echo "Terraform could not be found on your system, please install it globally"
    exit 1
else 
  echo "Terraform OK"
fi
for i in $PROVIDERS; do
    if test -f "../blueprints/${i}/credentials"; then
        echo "File credentials for ${i} OK"
    else 
        echo "File credentials for ${i} was not found"
        exit 2
    fi
done

echo "Requirements...OK"

for i in $PROVIDERS; do
    PROVIDER=$i
    echo "Unprovisioning ${i} environment..."
    cd ../blueprints/$i
    if [ "${PROVIDER}" == "azure" ]; then
        CLIENT_ID=$(cat credentials | grep client_id | awk -F: '{print $2}')
        CLIENT_SECRET=$(cat credentials | grep client_secret | awk -F: '{print $2}')
        TENANT_ID=$(cat credentials | grep tenant_id | awk -F: '{print $2}')
        SUBSCRIPTION_ID=$(cat credentials | grep subscription_id | awk -F: '{print $2}')
        VARS="  -var client_secret=${CLIENT_SECRET} \
                -var client_id=${CLIENT_ID} \
                -var subscription_id=${SUBSCRIPTION_ID} \
                -var tenant_id=${TENANT_ID} \
            "
    fi
    terraform init >> /dev/null
    terraform destroy $VARS  -auto-approve
    # >> last-unprovision.log
    for x in $FAAS; do
        rm -f "url_${x}.tmp"
    done
    cd - >> /dev/null
done 



