# Prepare Environment for Terraform run
## Set Target Organization ID, Billing Account, Folder ID
```
export GOOGLE_REGION=us-east1
export TF_VAR_org_id=10xxxxxxxx777
export TF_VAR_billing_account=03xxxx-xxxxxx-xxxDDD
export TF_VAR_env_folder=4xxxxxxxxxx5
```
## Bootstrap TF project and state bucket
```
./bootstrap_tf_project.sh
source .tf_env
```
