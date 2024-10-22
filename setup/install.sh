#!/bin/bash

echo ".........----------------#################._.-.-INSTALL-.-._.#################----------------........."
source ~/.bashrc

apt-get autoremove -y  #removes the packages that are no longer needed
apt-get update
systemctl daemon-reload


echo "------------ Docker -------------------"

sudo apt-get update -y

sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

sudo apt-get install -y docker-ce 

sudo docker run hello-world

sudo groupadd docker
sudo usermod -aG docker ubuntu

sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

sudo apt-get install net-tools

base=https://github.com/docker/machine/releases/download/v0.14.0 &&
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
sudo install /tmp/docker-machine /usr/local/bin/docker-machine 


#-------- Kubernetes --------------
sudo cat /sys/class/dmi/id/product_uuid

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet

ip route show # Look for a line starting with "default via"
# if any issue related to 
sudo apt-get -y install socat

# if any issues related to containerd not working
   #sudo rm /etc/containerd/config.toml
   #sudo systemctl restart containerd


sudo kubeadm init


To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf


kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.30/net.yaml

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.35.221:6443 --token mnr289.f2bw38yszdywjzko \
        --discovery-token-ca-cert-hash sha256:2fb10cde4188e668dce2416d474fd0cd0d77902623495360af73bf21bf96beec


