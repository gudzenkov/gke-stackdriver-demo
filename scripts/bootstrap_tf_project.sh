#!/usr/bin/env bash

# Variables required:
# export TF_VAR_org_id=10xxxxxxxx777
# export TF_VAR_billing_account=03xxxx-xxxxxx-xxxDDD
# export TF_VAR_env_folder=4xxxxxxxxxx5

BACKEND_CONFIG="tf/backend.tf"

ROOT=$(git rev-parse --show-toplevel)
cd $ROOT
#Load environment variables
[ -z "$1" ] && ENV_FILE=".tf_env" || ENV_FILE=$1
[ -f "$ENV_FILE" ] && echo "Loading $ENV_FILE ..." && source "$ENV_FILE"

# Required params:
[ -z "$TF_VAR_org_id" ] && echo "Variable TF_VAR_org_id is not set" && exit 1
[ -z "$TF_VAR_billing_account" ] && echo "Variable TF_VAR_billing_account is not set" && exit 1
[ -z "$TF_VAR_env_folder" ] && echo "Variable TF_VAR_env_folder is not set" && exit 1

if [ -z "$TF_ADMIN" ]; then
  echo "Generating new TF Admin Project ID.."
  TF_VAR_random_id=$((100000 + RANDOM % 999999))
  TF_ADMIN="tf-admin-${TF_VAR_random_id}"
  TF_VAR_state_bucket="tf-state-${TF_VAR_random_id}"
fi

TF_USER="tfadmin"
TF_IAM="${TF_USER}@${TF_ADMIN}.iam.gserviceaccount.com"
TF_ACCOUNT="serviceAccount:$TF_IAM"
OPS_ADMIN=$(gcloud config list account --format "value(core.account)")

echo
echo Current organization id: $TF_VAR_org_id
echo Folder for projects:     $TF_VAR_env_folder
echo Ops Admin e-mail:        $OPS_ADMIN
echo TF Admin project id:     $TF_ADMIN
echo TF Admin account:        $TF_IAM
echo

echo Updating $BACKEND_CONFIG ...
cat > "$BACKEND_CONFIG" <<EOF
  terraform {
    backend "gcs" {
      prefix  = "terraform/state/stackdriver"
      project = "$TF_ADMIN"
      bucket  = "$TF_VAR_state_bucket"
    }
  }
EOF

# Write environment variables into dot-env file
echo Saving $ENV_FILE ...
cat > "$ENV_FILE" <<EOF
export TF_VAR_org_id=$TF_VAR_org_id
export TF_VAR_billing_account=$TF_VAR_billing_account
export TF_VAR_env_folder=$TF_VAR_env_folder
export TF_VAR_admin_email=$OPS_ADMIN

export TF_VAR_state_bucket=$TF_VAR_state_bucket
export TF_ADMIN=$TF_ADMIN
export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/${TF_ADMIN}.json

export TF_VAR_stackdriver_project=$STACKDRIVER_PROJECT_ID
export TF_VAR_core_project=$CORE_PROJECT_ID
export TF_VAR_kube_project=$KUBE_PROJECT_ID
EOF

echo
echo -n "Create TF admin project (y/n)? "
read -t 3 answer
[ "$answer" != "y" -a "$answer" != "Y" ] && echo "Exiting." && exit 0

# Create terraform admin project
  gcloud projects create ${TF_ADMIN} --folder $TF_VAR_env_folder --set-as-default

# Link billing account
# !! REQUIRES privileges to link billing account (Billing account administrator on at least one billing account)
  gcloud beta billing projects link ${TF_ADMIN} --billing-account ${TF_VAR_billing_account}

# Enable Cloud Resource manager, Billing and Container APIs on terraform admin project
  gcloud services enable cloudresourcemanager.googleapis.com --project $TF_ADMIN
  gcloud services enable cloudbilling.googleapis.com --project $TF_ADMIN
  gcloud services enable container.googleapis.com --project $TF_ADMIN
  gcloud services enable iam.googleapis.com --project $TF_ADMIN
  gcloud services enable cloudbuild.googleapis.com --project $TF_ADMIN

# Create terraform service account
  gcloud iam service-accounts create $TF_USER --display-name "Terraform admin account" --project ${TF_ADMIN}

# Create keys for terraform account, this keys will be put to your home directory
  gcloud iam service-accounts keys create ${TF_ADMIN}.json --iam-account $TF_IAM
  mkdir -p ~/.config/gcloud && mv ${TF_ADMIN}.json ~/.config/gcloud
  GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/${TF_ADMIN}.json

# Grant the service account permission to view the Terraform Admin Project and manage Cloud Storage:
  gcloud projects add-iam-policy-binding ${TF_ADMIN} --member $TF_ACCOUNT --role roles/owner
  gcloud projects add-iam-policy-binding ${TF_ADMIN} --member $TF_ACCOUNT --role roles/storage.admin

# Grant the service account permission to create projects and assign billing accounts:
  gcloud alpha resource-manager folders add-iam-policy-binding $TF_VAR_env_folder --member $TF_ACCOUNT --role roles/owner
  gcloud alpha resource-manager folders add-iam-policy-binding $TF_VAR_env_folder --member $TF_ACCOUNT --role roles/resourcemanager.folderViewer
  gcloud alpha resource-manager folders add-iam-policy-binding $TF_VAR_env_folder --member $TF_ACCOUNT --role roles/resourcemanager.folderAdmin
  gcloud alpha resource-manager folders add-iam-policy-binding $TF_VAR_env_folder --member $TF_ACCOUNT --role roles/resourcemanager.folderIamAdmin
  gcloud alpha resource-manager folders add-iam-policy-binding $TF_VAR_env_folder --member $TF_ACCOUNT --role roles/resourcemanager.projectCreator
  # gcloud alpha resource-manager folders add-iam-policy-binding $TF_VAR_env_folder --member $TF_ACCOUNT --role roles/resourcemanager.projectDeleter

# Grant Organization-wide permissions for SVPC and Billing for TF service account
  gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} --member $TF_ACCOUNT --role roles/billing.user
  gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} --member $TF_ACCOUNT --role roles/compute.xpnAdmin

# Create the remote bucket in Cloud Storage (For Terraform remote state)
  gsutil mb -p ${TF_ADMIN} gs://${TF_VAR_state_bucket}
  gsutil versioning set on  gs://${TF_VAR_state_bucket}
