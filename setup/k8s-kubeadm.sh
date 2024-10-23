https://medium.com/@subhampradhan966/kubeadm-setup-for-ubuntu-24-04-lts-f6a5fc67f0df

sudo apt update && sudo apt upgrade -y
sudo apt install apt-transport-https curl -y

sudo apt install containerd -y

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/path/to/cluster-config


kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

kubectl get nodes
kubectl get pods --all-namespaces


# Join Command - token regenerate or use existing valid token

# https://ystatit.medium.com/regenerate-kubernetes-join-command-to-join-work-node-7eeb5d1f5787

There are two ways to deal with the above situations,

For either case, generate a new token
Construct the join command if still within expiration time

kubeadm token create --print-join-command

kubeadm token list

# Construct the join command
For either case, it is easier and simpler just to create a new token for join command but it makes no harm to know more about how to construct the command. The join command is structured as below,

kubeadm join <api-server-ip:port> --token <token-value> \
--discovery-token-ca-cert-hash sha256:<hash value>
So we need three information,

Api-server-ip and port, which you can find easily
Valid token
Token-ca-cert-hash value
On control plane node, run command below to get api-server-ip and port.

kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' && echo ""

Retrive token-ca-cert-hash value on any of the control plane node within the cluster.

openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
openssl rsa -pubin -outform der 2>/dev/null | \
openssl dgst -sha256 -hex | sed ‘s/^.* //’
kubeadm join https://172.31.34.35:6443 --token mtm0du.thnfm4whqygtkz22 \
--discovery-token-ca-cert-hash sha256:10b4d4f00d8d370dd8fa5934a0a2d8051e60159af778cca0ac07e0519d043977



