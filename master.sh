#!/bin/bash

if ! command -v ansible >/dev/null; then
	
	# Temel Bileşen ve kubectl..
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list 
	sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 
	
	sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common kubelet kubeadm kubectl  
	
	echo "-----------------------------İnstall Docker CE-----------------------------"
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
	  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) \
	stable"
	sudo apt-key fingerprint 0EBFCD88
	sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	sudo service docker status
	sudo usermod -aG docker vagrant 

	sudo swapoff -a

# Setup daemon.
# sudo cat > /etc/docker/daemon.json << sudo EOF { "exec-opts": ["native.cgroupdriver=systemd"],"log-driver": "json-file","log-opts": {"max-size": "100m"},"storage-driver": "overlay2"} EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
sudo systemctl daemon-reload
sudo systemctl restart docker
	
	sudo kubeadm init --apiserver-advertise-address="192.168.50.10" --apiserver-cert-extra-sans="192.168.50.10"  --node-name k8s-master --pod-network-cidr=192.168.0.0/16 >> config
	
	# Install pod network  https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
	# kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
	# kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

fi