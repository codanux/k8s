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


fi