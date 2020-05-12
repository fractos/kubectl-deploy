#!/bin/sh

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

echo "Downloading kubectl ${KUBECTL_VERSION}"

curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl 2> /dev/null && chmod +x kubectl && mv kubectl /usr/local/bin

echo "Applying deployment ${DEPLOYMENT_FILE}..."

kubectl apply -f ${DEPLOYMENT_FILE}

if [ $? -eq 0 ]; then
  echo "Verifying deployment status..."
  kubectl rollout status deployment/${DEPLOYMENT_NAME} 2> deployment-error.txt
  if [ $? -eq 0 ]; then
    echo "Deployment rollout verified"
    exit 0
  else
    echo "Deployment rollout failed!"
    cat deployment-error.txt
    echo "Rolling back deployment..."
    kubectl rollout undo deployment/${DEPLOYMENT_NAME}
    exit 1
  fi
else
  echo "Deployment could not be applied!"
  exit 1
fi
