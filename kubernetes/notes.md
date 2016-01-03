# Instructions for deployment with Docker and Kubernetes

## Install Docker for local development

## Create a container that serves the site

````
docker build -t hno-nginx:0.0.1 .
(docker rm hno-nginx)
docker run --name hno-nginx -p 80:80 hno-nginx:0.0.1
````

## Push the container to Google's container registry

````
docker tag hno-nginx:0.0.4 gcr.io/$GCP_PROJECT/hno-nginx:0.0.4
gcloud docker push gcr.io/$GCP_PROJECT/hno-nginx:0.0.4
````

## Create a k8s cluster

````
gcloud config set project $GCP_PROJECT
gcloud container clusters create $CLUSTER_NAME
gcloud container clusters list
````

## Instruct k8s to run the containers

````
gcloud compute addresses create site
(gcloud compute addresses list) # to get the $SITE_IP
kubectl run site --replicas=4 -l app=hno,version=0.0.4 --image=gcr.io/$GCP_PROJECT/hno-nginx:0.0.4
kubectl expose rc site --port=80 --target-port=80 --external-ip=$SITE_IP
gcloud compute http-health-checks create kube-proxy --port 10249 --request-path "/healthz"
gcloud compute target-pools create site --health-check kube-proxy
gcloud compute target-pools add-instances site --instances gke-k8s-test-d09a6f05-node-f6hn
gcloud compute forwarding-rules create site --port-range 80 --address $SITE_IP --target-pool site

Scale the pods
kubectl scale --replicas=3 replicationcontrollers site
````
