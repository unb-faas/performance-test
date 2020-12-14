#/bin/bash
PROVIDERS="aws"
FAAS="get post delete"
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

echo "Generating FaaS Packages..."
for i in $PROVIDERS; do
    cd ../faas/$i
    for x in $FAAS; do
        cd $x
        rm -f $x.zip
        zip $x.zip * >> /dev/null
        echo "  ${x} for ${i}...OK"
        cd - >> /dev/null
    done
    cd ..
done 

for i in $PROVIDERS; do
    PROVIDER=$i
    echo "Provisioning ${PROVIDER} environment..."
    cd ../blueprints/$PROVIDER
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
    terraform apply $VARS -auto-approve > last-provision.log
    for x in $FAAS; do
        cat last-provision.log | grep faas_${PROVIDER}_${x}_url | awk -F" = " '{print $2}' > "url_${x}.tmp"
    done
    cd - >> /dev/null
done 
