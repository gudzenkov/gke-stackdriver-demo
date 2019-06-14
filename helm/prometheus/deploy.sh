#!/bin/bash
# Steps to re-deploy Prometheus

helm delete --purge prometheus
helm install "$(dirname "$0")" --name prometheus --namespace monitoring
kubectl rollout status deployment/prometheus-server -n monitoring
export PROMETHEUS_IP=$(kubectl get svc --namespace monitoring prometheus-server -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
open http://$PROMETHEUS_IP:80/service-discovery
