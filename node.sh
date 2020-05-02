#!/bin/bash

if ! command -v ansible >/dev/null; then
    sudo swapoff -a

    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common  

	# kubelet kubeadm kubectl
	sudo apt-get update && sudo apt-get install -y apt-transport-https curl
    sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
    deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
	sudo systemctl enable kubelet.service

	echo "-----------------------------İnstall Docker CE-----------------------------"
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
	  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) \
	stable"
	sudo apt-key fingerprint 0EBFCD88
	sudo apt-get update 
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

	sudo usermod -aG docker vagrant 
    sudo systemctl enable docker.service
	
    sudo swapoff -a

	

fi