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
    echo "Provisioning ${i} environment..."
    cd ../blueprints/$i
    terraform init >> /dev/null
    terraform apply -auto-approve
    cd - >> /dev/null
done 



