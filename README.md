# FaaS performance evaluation
Performance test execution on AWS, GCP and Azure

Run script strategy

- Check requirements
  - Terraform
  - Jq
- Provision service using Terraform blueprints (one by one)
- Play tests
- Collect results
- Commit on this project
- Deprovision service using Terraform blueprints
- Shut down machine (if --restart-on-end is present on run script command)

# Create temporary credentials files
 - blueprints/aws/credentials
 - blueprints/gcp/credentials
 - blueprints/azure/credentials

# Provision
`cd scripts`
`./provision.sh`

# Unrovision
`cd scripts`
`./unprovision.sh`
