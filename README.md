# performance-test
Performance test on AWS, GCP and Azure

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

