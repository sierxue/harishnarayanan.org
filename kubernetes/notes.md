# Instructions for deployment with Docker and Kubernetes

## Install Docker for local development

## Create a container that serves the site

````
docker build -t hno-nginx:0.0.1 .
(docker rm hno-nginx)
docker run --name hno-nginx -p 80:80 hno-nginx:0.0.1
````

## Push the container to Google’s container registry

````
docker tag hno-nginx:0.0.4 gcr.io/$GCP_PROJECT/hno-nginx:0.0.4
gcloud docker push gcr.io/$GCP_PROJECT/hno-nginx:0.0.4
````

## Create a k8s cluster

````
gcloud config set project $GCP_PROJECT
gcloud config set compute/zone $GCP_COMPUTE_ZONE

gcloud container clusters create $GCP_CLUSTER_NAME
gcloud container clusters list
````

## Instruct k8s to deploy the site

````
kubectl create -f controller.yaml
(kubectl get pods)
# TODO: Health stuff is missing so load balancer can't determine whether a
# pod is properly scheduled
# TODO: Resource requirements of pods aren't specified so k8s can't
# intelligently schedule a pod.
kubectl create -f controller.yaml
(kubectl get pods)
kubectl create -f service.yaml
kubectl get services # to get $SITE_IP
````

# Scale the site
kubectl scale --replicas=3 rc website
