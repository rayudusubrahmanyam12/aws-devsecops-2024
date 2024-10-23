# https://devopscube.com/setup-argo-cd-using-helm/

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
change service type ClusterIP to NodePort for app-server
kubectl port-forward svc/argocd-server -n argocd 3000:443

The default username is admin. To get the password, execute the following command.

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode ; echo

# curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# chmod +x /usr/local/bin/argocd

You can clean up the setup using the following command.

kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

ArgoCD Setup Using Official Helm Chart
If you are setting up ArgoCD for project purposes, we highly recommend you setup using Helm charts rather than plain manifest files.

Follow the steps given below to setup ArgoCD using the official Argoproject helm chart.

Step 1: Add argo cd repo
Add Argo CD repo to your system to download the helm chart to set up Argo CD. Run the following command to add the repo

helm repo add argo https://argoproj.github.io/argo-helm
Now, list every repo with the word argo using the command

helm search repo argo





