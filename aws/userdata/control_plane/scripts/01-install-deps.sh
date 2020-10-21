#!/bin/bash


export DEBIAN_FRONTEND=noninteractive
AWS_DEFAULT_REGION="$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')"


#####################################################################
# Install Kubernetes and Critical Stack packages
#####################################################################

# the hostname MUST be set correctly so that cert SANs match for authz
hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/hostname)

curl -sL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

curl -sL https://packagecloud.io/criticalstack/public/gpgkey | apt-key add -
apt-add-repository https://packagecloud.io/criticalstack/public/ubuntu

apt-get update
apt-get install -y awscli e2d=0.4.* criticalstack kubelet=${kubernetes_version}-00 kubectl
apt-mark hold criticalstack
apt-mark hold kubelet
systemctl stop kubelet.service


#####################################################################
# Install helm
#####################################################################

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
