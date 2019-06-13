## Monitoring deployment (with Helm charts)
* Deploy charts and wait for completion
```
helm install ./helm/prometheus --name prometheus --namespace monitoring
helm install ./helm/grafana --name grafana --namespace monitoring

kubectl rollout status deployment/prometheus-server -n monitoring
kubectl rollout status deployment/grafana -n monitoring
```

* Check Prometeus status:
```
## If Prometheus exposed via ClusterIP
PROMETHEUS_POD=$(kubectl get pod --namespace monitoring --selector="app=prometheus,component=server,release=prometheus" --output jsonpath='{.items[0].metadata.name}')
kubectl port-forward $PROMETHEUS_POD -n monitoring 8080:9090 &
PROMETHEUS_IP=localhost
PROMETHEUS_PORT=8080

## If Prometheus exposed via LoadBalancer
export PROMETHEUS_IP=$(kubectl get svc --namespace monitoring prometheus-server -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PROMETHEUS_PORT=80

## Check all Targets are `Up` state
open http://$PROMETHEUS_IP:$PROMETHEUS_PORT/targets
```

* Here we added Custom Scrapers for:
  * ingress-nginx-endpoints
  * kubernetes-kubelet
  * kubernetes-cadvisor
  * kubernetes-kube-state

# Configure Grafana
* Get Grafana Admin password
```
GRAFANA_URL=$(kubectl get service grafana -n monitoring  -o json | jq -r '.status.loadBalancer.ingress[0].ip')
ADMIN_PASS=$(kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo Grafana credentials: admin / $ADMIN_PASS
```
* Once logged in with above admin cred - add Kubernetes cluster:
```
open http://$GRAFANA_URL/plugins/grafana-kubernetes-app/edit
```
> Press "Enable API" button
> Set Kube URL to `https://kubernetes.default.svc`<br />
> Access: `Server (default)`<br />
> Auth: `Basic` + `With CA cert`<br />
> User: `kubeadmin`
> Put Password and CA cert from your Kubernetes Cluster Endpoint Credentials

* Select Datasource: `Prometheus` and press *Save*<br />
:exclamation: DON'T press *Deploy* - that will break things as `Namespace: default` is used.<br />
:warning: The Deploy button generally will do the following: <br />
  * A prometheus configmap which contains the prometheus jobs to collect metrics for kubernetes app dashboards<br />
  * Node Exporter deployment <br />
  * Kube-State Metrics deployment<br />

* Hereby we need to deploy adjusted Node Exporter and Kube-State Metrics with `Namespace: monitoring`<br />
```
kubectl apply -f helm/grafana/grafanak8s-kubestate-deploy.json
kubectl apply -f helm/grafana/grafanak8s-node-exporter-ds.json
```

# TBD
## Add `grafana-user` service-user to let Grafana gather data via Kube API
```
GRAFANA_SECRET=$(kubectl get serviceaccounts -n kube-system grafana-user -o jsonpath="{.secrets[0].name}")
GRAFANA_TOKEN=$(kubectl get secret -n kube-system $GRAFANA_SECRET -o jsonpath="{.data.token}")
CA_CERT=$(kubectl get secret -n kube-system $GRAFANA_SECRET -o jsonpath="{.data.ca\.crt}")

echo "========================================"
echo Grafana credentials: admin / $ADMIN_PASS
echo Kubernetes auth user: grafana-user
echo Kubernetes auth password: $GRAFANA_TOKEN
echo Kubernetes CA cert: $CA_CERT
echo "========================================"
```
## Add Grafana FW rules provision
```
gcloud compute firewall-rules create k8s-fw-a5b3830e1547b11e9b06942010a00000 --network kwdev --description "{\"kubernetes.io/service-name\":\"monitoring/grafana\", \"kubernetes.io/service-ip\":\"35.237.190.67\"}" --allow tcp:80 --source-ranges 0.0.0.0/0 --target-tags gke-kubernetes-green-475ddc7a-node --project kw-core-dev-us-east1-57cc

gcloud compute firewall-rules create k8s-35874c3f6e748fe6-node-http-hc --network kwdev --description "{\"kubernetes.io/cluster-id\":\"35874c3f6e748fe6\"}" --allow tcp:10256 --source-ranges 130.211.0.0/22,209.85.152.0/22,209.85.204.0/22,35.191.0.0/16 --target-tags gke-kubernetes-green-475ddc7a-node --project kw-core-dev-us-east1-57ccqq
```

