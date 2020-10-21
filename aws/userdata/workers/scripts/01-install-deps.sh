#!/bin/bash


export DEBIAN_FRONTEND=noninteractive


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
apt-get install -y criticalstack kubelet=${kubernetes_version}-00 kubectl
apt-mark hold criticalstack
apt-mark hold kubelet
systemctl stop kubelet.service