# Prepare Environment for Terraform run
## Set Target Organization ID, Billing Account, Folder ID
```
export GOOGLE_REGION=us-east1
export GOOGLE_ZONE=us-east1-b
export TF_VAR_org_id=10xxxxxxxx777
export TF_VAR_billing_account=03xxxx-xxxxxx-xxxDDD
export TF_VAR_env_folder=4xxxxxxxxxx5
```

# Create Stackdriver Workspace
```
open "https://console.cloud.google.com/monitoring?project=${STACKDRIVER_PROJECT_ID}"
```

*	Add Google Cloud Platform projects to monitor - select assosiated projects - click Continue
*	Monitor AWS accounts - Skip AWS Setup
*	Install the Stackdriver Agents - click Continue
*	Get Reports by Email - select No reports then Continue.
*	You see the message "Gathering information..." at the top of the page. Click Launch monitoring when it finishes:

# Deploy Stackdriver Alert Policies and Uptime Checks with Terraform
## Bootstrap TF project and state bucket
```
./scripts/bootstrap_tf_project.sh
source .tf_env
```
## Deploy Stackdriver Alert Policies and Uptime checks
```
cd tf
terraform init
terraform plan --out=stackdriver.tfplan
terraform apply stackdriver.tfplan
```

# Demo Infrastructure setup
## Set Project
```
gcloud config set project $KUBE_PROJECT_ID
gcloud config set compute/region $GOOGLE_REGION
gcloud config configurations list --filter IS_ACTIVE=True
gcloud container clusters list

```
## Create Demo Kube cluster and Cloud Source Repo
```
gcloud source repos create $KUBE_CLUSTER
gcloud container clusters create $KUBE_CLUSTER \
      --region $GOOGLE_REGION \
      --enable-ip-alias \
      --enable-stackdriver-kubernetes \
      --enable-autoscaling --min-nodes 1 --max-nodes 2
      --scopes=https://www.googleapis.com/auth/cloud-platform
gcloud container clusters get-credentials --region $GOOGLE_REGION $KUBE_CLUSTER
kubectl get nodes
```

# Deploy Demo Application
NOTE: This lab uses a fork of [Microservices Demo application](https://github.com/GoogleCloudPlatform/microservices-demo) build to aid in the troubleshooting exercises.
Build and Deploy is done by [Skaffold](http://skaffold.dev/)

## Download the source and put the code in the Cloud Source Repo
```
git clone https://github.com/blipzimmerman/microservices-demo-1
cd microservices-demo-1
git remote add apm-demo https://source.developers.google.com/p/$KUBE_PROJECT_ID/r/$KUBE_CLUSTER
git push apm-demo master
git checkout APM-Troubleshooting-Demo-2
git push apm-demo APM-Troubleshooting-Demo-2
```
## Deploy and check frontend-external service
```
skaffold deploy
kubectl get pods

SVC=frontend-external
export EXTERNAL_IP=$(kubectl get service $SVC -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -sI http://$EXTERNAL_IP

open http://$EXTERNAL_IP
```

## Worknotes
SRC=accl-19-dev
DST=gke-private-demo1
TAG1=dd14b8e
TAG2=accl-demo
APPS1="adservice cartservice checkoutservice currencyservice emailservice frontend loadgenerator paymentservice productcatalogservice recommendationservice shippingservice"
APPS2="currencyservice frontend recommendationservice"
for app in $APPS1; do docker image pull gcr.io/$SRC/$app:$TAG2; done
for app in $APPS1; do docker image tag gcr.io/$SRC/$app:$TAG2 gcr.io/$DST/$app:$TAG2; done
for app in $APPS1; do docker image push gcr.io/$DST/$app:$TAG2; done
