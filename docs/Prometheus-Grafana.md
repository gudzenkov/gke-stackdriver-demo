## Monitoring deployment (with Helm charts)
* Deploy charts and wait for completion
```
helm init --service-account tiller
kubectl apply -f helm/monitoring-ns.yaml -f helm/tiller/helm-service-account.yaml

helm install helm/prometheus --name prometheus --namespace monitoring
helm install helm/grafana --name grafana --namespace monitoring

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
:exclamation: DON'T press *Deploy* - that will break things as `namespace: default` would be used instead of `namespace: monitoring`.<br />
:warning: The Deploy button generally will do the following: <br />
  * A prometheus configmap which contains the prometheus jobs to collect metrics for kubernetes app dashboards<br />
  * Node Exporter deployment <br />
  * Kube-State Metrics deployment<br />

* Hereby we need to deploy adjusted Node Exporter and Kube-State Metrics with `namespace: monitoring`<br />
```
kubectl apply -f helm/grafana/grafanak8s-kubestate-deploy.json
kubectl apply -f helm/grafana/grafanak8s-node-exporter-ds.json
```

