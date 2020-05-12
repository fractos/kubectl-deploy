#!/bin/sh

set -e

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

echo "Downloading kubectl ${KUBECTL_VERSION}"

curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl 2> /dev/null && chmod +x kubectl && mv kubectl /usr/local/bin

sh -c "kubectl version --short"
