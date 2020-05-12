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
    - uses: actions/checkout@master
    - name: deploy to cluster
      uses: fractos/kubectl@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
      with:
        args: set image --record deployment/my-app container=${{ github.repository }}:${{ github.sha }}
    - name: verify deployment
      uses: fractos/kubectl@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        KUBECTL_VERSION: "1.15"
      with:
        args: '"rollout status deployment/my-app"'
```

## Secrets

`KUBE_CONFIG_DATA` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```

## Environment

`KUBECTL_VERSION` - (optional): Used to specify the kubectl version. If not specified, this defaults to kubectl 1.13

**Note**: Do not use kubectl config view as this will hide the certificate-authority-data.