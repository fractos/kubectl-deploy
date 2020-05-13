#!/bin/sh

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

echo "Downloading kubectl ${KUBECTL_VERSION}"

curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl 2> /dev/null && chmod +x kubectl && mv kubectl /usr/local/bin

echo "Applying deployment ${DEPLOYMENT_FILE}..."

kubectl apply -f ${DEPLOYMENT_FILE} ${DRY_RUN}

if [ $? -eq 0 ]; then
  echo "Verifying deployment status..."
  kubectl rollout status deployment/${DEPLOYMENT_NAME} 2> deployment-error.txt
  if [ $? -eq 0 ]; then
    echo "Deployment rollout verified"
    exit 0
  else
    echo "Deployment rollout failed!"
    cat deployment-error.txt
    grep "exceeded its progress deadline" deployment-error.txt
    if [ $? -eq 0 ]; then
      echo "Deployment exceeded its progress deadline, rolling back deployment..."
      kubectl rollout undo deployment/${DEPLOYMENT_NAME} ${DRY_RUN}
      if [ $? -eq 0 ]; then
        echo "Verifying rollback..."
        kubectl rollout status deployment/${DEPLOYMENT_NAME}
        if [ $? -eq 0 ]; then
          echo "Deployment rollback completed"
          echo "::set-output name=status::rollbacksuccess"
        else
          echo "Deployment rollback failed!"
          echo "::set-output name=status::rollbackfailed"
        fi
      else
        echo "Couldn't rollback deployment!"
        echo "::set-output name=status::rollbackerror"
      fi
    else
      echo "Some other error occurred during rollout status check. No rollback."
      echo "::set-output name=status::deployerror"
    fi
  fi
else
  echo "Deployment could not be applied!"
  echo "::set-output name=status::deployfailed"
fi
exit 1
