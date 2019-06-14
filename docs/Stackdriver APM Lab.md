
## Define SLI
- request latency
- error rate
- availability
- throughput RPS
- durability

## Enable APIs
```
gcloud config set project gke-private-demo1

gcloud services enable cloudbuild.googleapis.com
gcloud services enable sourcerepo.googleapis.com
gcloud services enable stackdriver.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable cloudtrace.googleapis.com
gcloud services enable clouddebugger.googleapis.com
gcloud services enable cloudprofiler.googleapis.com
```


## Setup Alert Policy
### Latency
  - 99% of requests from the previous 60 minute period are services in under 3 seconds
```
Name:           Front End Latency
Metric:         custom.googleapis.com/opencensus/grpc.io/client/roundtrip_latency
Resource type:  global
Reducer:        99th percentile
Triggers:       Any time series violates
Condition:      Above
Threshold:      500
For:            1 minute
```
### Error rate
  - 0 Errors in the previous 60 minute period
```
Name:           Error Rate SLI
Metric:         logging.googleapis.com/log_entry_count
Resource type:  Kubernetes Container
Filter:         severity=ERROR pod_id=~"currencyservice.*"
Alignment:      5 minutes
Triggers:       Any time series violates
Condition:      Above
Threshold:      1
For:            1 minute
```
### Availability
 - 99% of requests are successful over the previous 60 minute period

## Deploy new release
Update the kubernetes manifests to pull the new images with below tag:
```
image tag: rel013019
imagePullPolicy: Always
```
in the following files:
- kubernetes_manifests/recommendationservice.yaml
- kubernetes_manifests/currencyservice.yaml
- kubernetes_manifests/frontend.yaml
```
skaffold deploy
kubectl get pods
kubectl get svc frontend-external
```

## Latency SLO Violation
- Once on the Hipster Shop website, click on a Buy and/or Add to Cart for a couple of items to send some traffic
- Click on the Latency Policy in the Incident section to learn more about what's going on. You can see that your latency is significantly exceeding the threshold that was set up
- Click on Trace -> Trace List page
- enter "Recv./cart" in the Request filter box to filter for all the cart operations and look for similar traces
- Set the time period to 1 hour so that it includes traces that occurred before the issue.
- ListRecommendations is being called many times per request, causing significant additional latency

### Fix the latency issue that the last release created
```
image tag: rel013019fix
```
- kubernetes_manifests/recommendationservice.yaml
- kubernetes_manifests/frontend.yaml
```
skaffold deploy
```

### Validate Fix
Return to Stackdriver and go to the Metrics Explorer (Resources >Metrics Explorer).
```
Metric: roundtrip_latency
chart type: Line
```
## Error Rate SLO Violation
### Monitoring Overview in Stackdriver -> Error Rate SLI incident -> Error Reporting
  - You can see that the currencyservice pod is logging significantly more errors than it was previously
  - Acknowledge the incident so that no further notification escalation takes place
```
resource.type="k8s_container"
resource.labels.cluster_name="shop-cluster"
severity>=ERROR
labels."k8s-pod/app"="currencyservice"
```

### Error Reporting -> Error: Conversion is Zero
  - Check what specific calls were related to the error.
  - Click on the lowest call showing here: */usr/src/app/server/js:131*.
  This will load you into Stackdriver Debug.
  - Select the source code that is running from Cloud Source Repositories
  - Select your source with:
    ```
    Repository: shop-cluster
    Tagged version or branch: APM-Troubleshooting-Demo-2
    ```
### Snapshots to inspect the variables as the application progresses.
  - See if the previous branch "Master" had this code error on line 137.
Go back to the Console and inspect the code using Cloud Source Repositories
You can set Snaphot breakpoint at any line number and inspect variables caught live with a next app invocation.
Either create these via cli
```
gcloud debug snapshots create --target=currencyservice-1.0.0 src/currencyservice/server.js:136
gcloud debug snapshots create --target=currencyservice-1.0.0 src/currencyservice/server.js:155
```

### Deploy Fixed revision
```
currencyservice.yaml
image tag: rel013019fix
```

## Application optimization with Stackdriver APM
*currencyservice* service is using more CPU than expected based on the usage of the system
- Stackdriver Profiler -> frontend service -> the CPU time

  Profiler takes random sample profiles of the system and combines the data to show you what functions are using the most resources.

  X-axis is the amount of CPU and the Y-axis shows parent child relationships.

  In this case the majority of the CPU is used by the ServeHTTP call, half of this is caused by viewCartHandler, which in turn is mostly caused by getRecommendations
