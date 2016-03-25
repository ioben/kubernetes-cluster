#!/usr/bin/env bash

cat <<EOF > /etc/kubernetes/kubelet
# The address for the info server to serve on
KUBELET_ADDRESS="--address=0.0.0.0"

# The port for the info server to serve on
KUBELET_PORT="--port=10250"

# You may leave this blank to use the actual hostname
# KUBELET_HOSTNAME="--hostname-override=minion"

# Location of the api-server
KUBELET_API_SERVER="--api-servers=http://master:8080"

# Add your own!
KUBELET_ARGS=""
EOF

cat <<EOF > /etc/kubernetes/proxy
###
# kubernetes proxy config

# default config should be adequate

# Add your own!
KUBE_PROXY_ARGS="--master http://master:8080"
EOF

for SERVICES in flanneld kube-proxy kubelet docker; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES
done
