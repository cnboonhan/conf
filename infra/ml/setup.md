# Infra Setup

## K3S Setup
```
curl -sfL https://get.k3s.io | sh - 
sudoedit /etc/systemd/system/k3s.service
# Add --write-kubeconfig-mode 644 to ExecStart
# Add to bashrc: alias k="k3s kubectl"
# Add to bashrc: export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

## View Dashboard
```
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443 --address 0.0.0.0
# Create a ServiceAccount
kubectl create serviceaccount admin-user -n kubernetes-dashboard

# Bind the ServiceAccount to the cluster-admin role
kubectl create clusterrolebinding admin-user \
  --clusterrole=cluster-admin \
  --serviceaccount=kubernetes-dashboard:admin-user

# Get the bearer token
kubectl -n kubernetes-dashboard create token admin-user
```

## Install MinIO
```
helm repo add minio-operator https://operator.min.io
helm install \
  --namespace minio-operator \
  --create-namespace \
  operator minio-operator/operator

helm install \
--namespace minio \
--create-namespace \
--values minio.values.yaml \
minio minio-operator/tenant

kubectl apply -f minio-dev.yaml

curl https://dl.min.io/client/mc/release/linux-amd64/mc -o mc
chmod +x mc
sudo mv mc /usr/local/bin

kubectl port-forward pod/minio 9000 9090 -n minio-dev
```

## Install Nvidia and JupyterHub
```
helm repo add jupyterhub https://hub.jupyter.org/helm-chart/
helm upgrade --cleanup-on-fail \
  --install jupyterhub jupyterhub/jupyterhub \
  --namespace jupyterhub \
  --create-namespace \
  --values jupyterhub.config.yaml

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
&& curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt install nvidia-container-toolkit*
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
sudo nvidia-ctk runtime configure --runtime=containerd
sudo systemctl restart containerd
sudo systemctl restart k3s.service
sudo grep nvidia /var/lib/rancher/k3s/agent/etc/containerd/config.toml

helm repo add nvidia https://nvidia.github.io/gpu-operator
helm install --wait --generate-name nvidia/gpu-operator


```
