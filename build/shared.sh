#!/usr/bin/env bash

set -x
# TODO
cat <<EOF > /etc/hosts
127.0.0.1 localhost
10.0.20.10 master
10.0.20.11 minion1
10.0.20.12 minion2
EOF

cat <<EOF > /etc/yum.repos.d/virt7-docker.repo
[virt7-docker-common-release]
name=virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os/
gpgcheck=0
EOF

yum install -y --enablerepo=virt7-docker-common-release kubernetes
yum install -y flannel

cat <<EOF > /etc/sysconfig/flanneld
# Flanneld configuration options

# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD="http://master:2379"

# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_KEY="/coreos.com/network"

# Any additional options that you want to pass
FLANNEL_OPTIONS=""
EOF

cat <<EOF > /etc/kubernetes/config
# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd-servers=http://master:2379"

# logging to stderr means we get it in the systemd journal
KUBE_LOGTOSTDERR="--logtostderr=true"

# journal message level, 0 is debug
KUBE_LOG_LEVEL="--v=0"

# Should this cluster be allowed to run privileged docker containers
KUBE_ALLOW_PRIV="--allow-privileged=false"
EOF

systemctl disable iptables-services firewalld || echo
systemctl stop iptables-services firewalld || echo

echo "ADD_REGISTRY='--add-registry 10.0.20.10:5000'" >> /etc/sysconfig/docker
echo "INSECURE_REGISTRY='--insecure-registry 10.0.20.10:5000'" >> /etc/sysconfig/docker
