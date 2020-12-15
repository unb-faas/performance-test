# FaaS performance evaluation
Performance test execution on Function as a Services

## Purpose

This project aims to promote performance tests in Function as a Service of several providers using different approaches on different levels of competition.

## Archtecture

- FaaS as API REST to a noSQL DBaaS

## Operational FaaS
 - Amazon Web Services Lambda
 - Google Cloud Function

## Scripts

### Provision

  This script configures all resources in the clouds the is necessary to run the workloads tests.

  - Requirements:

    - credentials files present and filled inside all providers folders in blueprint folder
    - software: curl, terraform, jq and zip

  - How to run:

    - `cd ../scripts/`
    - `./provision.sh`

  - Output:

    - Provisioning log

### Upload

  This script sends to the cloud an defined amount of data from the dataset using the POST method of the FaaS provisioned by the Provision script.

  - Requirements:
    - Execution of Provision script
    - Download of the dataset file (even if it was partial), the script will try to download

  - How to run:

    - `cd ../scripts/`
    - `./upload.sh`

  - Output:
    - Will generate files in results/upload folder with each request performed and the response added by begin and end timestamps
    - Upload sequence number in order to follow the process

### Workloads

  This script performs the tests based on the configured parameters:
   - PROVIDERS: a list of the provider where the tests will run
   - REPETITIONS: how many times the tests will be repeated
   - CONCURRENCE: how many requests will me made at the same time
   - WAIT_TIME: the interval between the tests
   - TIMEOUT: how long the requests will be waited before fail

  - Requirements:
    - Execution of upload script
 
  - How to run:
    - `cd ../scripts/`
    - `./workloads.sh`

  - Output:
    - Will generate files in results/workloads folder with each request performed and the response added by begin and end timestamps

### Consolidation

  This script reads all files present in result folder and generates consolidation.txt files on work executions level and concurrence level.

  - Requirements:
    - Execution of workloads script
 
  - How to run:
    - `cd ../scripts/`
    - `./consolidation.sh`

  - Output:
    - Will generate files in results folder with average execution time, errors and a counter

### Clean database

  This script make requests to the FaaS, obtain ids of the objects and then make requests in order to promote the deletetion of the records in the database.

  - Requirements:
    - Execution of upload script

  - How to run:

    - `cd ../scripts/`
    - `./clean-database.sh`

  - Output:
    - Will generate files in results/delete folder with each request performed and the response added by begin and end timestamps
    - Upload sequence number in order to follow the process

### Unprovision

  This script unconfigures all resources in the clouds the is necessary to run the workloads tests.

  - Requirements:

    - credentials files present and filled inside all providers folders in blueprint folder

  - How to run:

    - `cd ../scripts/`
    - `./unprovision.sh`

  - Output:

    - Unprovisioning log