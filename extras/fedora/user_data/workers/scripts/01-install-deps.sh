#!/bin/bash


export AWS_DEFAULT_REGION="$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')"
dnf upgrade -y
apt-get update && apt-get install -y awscli


#####################################################################
# Install Kubernetes and Critical Stack packages
#####################################################################

# the hostname MUST be set correctly so that cert SANs match for authz
hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/hostname)

# install kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

PACKAGECLOUD_TOKEN=c349500516f09acede346c1ffab7f99d0fb544d0ec35f518
curl -s https://packagecloud.io/install/repositories/criticalstack/public/script.rpm.sh | sudo bash
curl -s https://$PACKAGECLOUD_TOKEN:@packagecloud.io/install/repositories/criticalstack/private/script.rpm.sh | sudo bash

dnf install -y awscli containerd cri-tools kubectl kubelet-${kubernetes_version} kubernetes-cni
dnf download criticalstack-crit
rpm -ivh --force criticalstack-crit*.rpm

systemctl enable --now kubelet containerd
