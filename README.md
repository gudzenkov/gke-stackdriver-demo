# Prepare Environment for Terraform run
## Set Target Organization ID, Billing Account, Folder ID
```
export GOOGLE_REGION=us-east1
export TF_VAR_org_id=10xxxxxxxx777
export TF_VAR_billing_account=03xxxx-xxxxxx-xxxDDD
export TF_VAR_env_folder=4xxxxxxxxxx5
```
## Set Project IDs to monitor with Stackdriver
```
export CORE_PROJECT_ID="gke-private-svpc-service"
export STACKDRIVER_PROJECT_ID="gke-private-svpc-service"
export KUBE_PROJECT_ID="gke-private-demo1"
export KUBE_CLUSTER="gke-private-demo1"
```
## To use Stackdriver, your project must be in a Stackdriver workspace
```
open "https://console.cloud.google.com/monitoring?project=${CORE_PROJECT_ID}"
```

*	Add Google Cloud Platform projects to monitor - select assosiated projects - click Continue
*	Monitor AWS accounts - Skip AWS Setup
*	Install the Stackdriver Agents - click Continue
*	Get Reports by Email - select No reports then Continue.
*	You see the message "Gathering information..." at the top of the page. Click Launch monitoring when it finishes:


## Bootstrap TF project and state bucket
```
./bootstrap_tf_project.sh
source .tf_env
```
## Deploy Stackdriver Alert Policies and Uptime checks
```
cd tf
terraform init
terraform plan
terraform apply
```

