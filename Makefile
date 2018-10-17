init-cluster:
	gcloud beta container --project "k8s-clusters" clusters create "istio-lab" --zone "europe-west4-c" --username "admin" --cluster-version "1.10.7-gke.6" --machine-type "n1-standard-2" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "4" --enable-cloud-logging --enable-cloud-monitoring --network "projects/k8s-clusters/global/networks/default" --subnetwork "projects/k8s-clusters/regions/europe-west4/subnetworks/default" --enable-autoscaling --min-nodes "2" --max-nodes "5" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair

init-istio:
	kubectl create clusterrolebinding cluster-admin-binding  --clusterrole=cluster-admin  --user="$(gcloud config get-value core/account)"
  
	kubectl apply -f /home/mrb/istio/istio-1.0.2/install/kubernetes/istio-demo-auth.yaml


setup-istio-demo-bookinfo:
	kubectl apply -f <(istioctl kube-inject -f samples/bookinfo/platform/kube/bookinfo.yaml)

	kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

	kubectl get svc istio-ingressgateway -n istio-system
