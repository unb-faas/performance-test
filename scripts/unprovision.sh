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
    echo "Unprovisioning ${i} environment..."
    cd ../blueprints/$i
    terraform init >> /dev/null
    terraform destroy -auto-approve >> last-unprovision.log
    for x in $FAAS; do
        rm -f "url_${x}.tmp"
    done
    cd - >> /dev/null
done 



