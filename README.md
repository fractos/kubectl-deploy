# Github Action for Kubernetes deployment and rollback

This will apply a deployment using kubectl, verify the deployment and roll it back if it failed.

Thanks to [@steebchen](https://github.com/steebchen) for their https://github.com/steebchen/kubectl repository which was used as a development base.

## Usage

`.github/workflows/push.yml`

```yaml
on: push
name: deploy
jobs:
  deploy:
    name: deploy to cluster
    runs-on: ubuntu-latest
    steps:
    - name: Test Deployment
      id: test-deployment
      uses: fractos/kubectl-deploy@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        KUBECTL_VERSION: v1.14.10
        DEPLOYMENT_FILE: deployment.yml
        DEPLOYMENT_NAME: hello-world
```

## Secrets

`KUBE_CONFIG_DATA` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```

## Environment

`KUBECTL_VERSION` - (optional): Used to specify the kubectl version. If not specified, this defaults to kubectl v1.13.12

`DEPLOYMENT_FILE` -: The name of the deployment manifest to apply.
`DEPLOYMENT_NAME` -: The name of the deployment itself (without the `deployment/` prefix).