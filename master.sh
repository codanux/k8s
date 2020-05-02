#!/bin/bash

if ! command -v ansible >/dev/null; then
	
	sudo su
	swapoff -a

    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common  

	# kubelet kubeadm kubectl
	apt-get update && sudo apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
    deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl

    systemctl daemon-reload
    systemctl restart kubelet
	systemctl enable kubelet.service

	echo "-----------------------------İnstall Docker CE-----------------------------"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	apt-key fingerprint 0EBFCD88
	apt-get update 
    apt-get install -y docker-ce docker-ce-cli containerd.io
	
	systemctl enable docker.service
	service docker status
	usermod -aG docker vagrant 
	
# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
	mkdir -p /etc/systemd/system/docker.service.d

	systemctl daemon-reload
	systemctl restart docker

	kubeadm init --pod-network-cidr=192.168.0.0/16 >> config

	# Install pod network  https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
	# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
	# watch kubectl get pods --all-namespaces
fi