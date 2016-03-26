#!/usr/bin/env bash

yum install -y etcd
sed -i 's@\(ETCD_LISTEN_CLIENT_URLS\).*@\1="http://0.0.0.0:2379"@' /etc/etcd/etcd.conf

cat <<EOF > flannel-config.json
{
    "Network": "18.16.0.0/16",
    "SubnetLen": 24,
    "Backend": {
        "Type": "vxlan",
        "VNI": 1
     }
}
EOF

systemctl start etcd
sleep 2
etcdctl set /coreos.com/network/config < flannel-config.json

cat <<EOF > /etc/kubernetes/scheduler
###
# kubernetes scheduler config

# default config should be adequate

# Add your own!
KUBE_SCHEDULER_ARGS="--master=http://master:8080"
EOF

cat <<EOF > /etc/kubernetes/apiserver
# The address on the local server to listen to.
KUBE_API_ADDRESS="--address=0.0.0.0"

# The port on the local server to listen on.
KUBE_API_PORT="--port=8080"

# How the replication controller and scheduler find the kube-apiserver
KUBE_MASTER="--master=http://master:8080"

# Port kubelets listen on
KUBELET_PORT="--kubelet-port=10250"

# Address range to use for services
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.250.0.0/16"

# Add your own!
KUBE_API_ARGS=""
EOF

yum install -y docker-distribution


for SERVICES in etcd flanneld docker-distribution kube-apiserver kube-controller-manager kube-scheduler; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status -l $SERVICES
done
