#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_ROOT="$(cd "$(dirname "$0")" && pwd -P)"
bin="${SCRIPT_ROOT}/bin"
mkdir -p "${bin}"

echo "+++ Grabbing tools needed for cert-manager demo"

echo "+++ Fetching 'kind'"
if [[ ! -f "${bin}/kind" ]]; then
  if [[ "$(uname)" == "Darwin" ]]; then
    curl -Lo "${bin}/kind" https://github.com/kubernetes-sigs/kind/releases/download/0.1.0/kind-darwin-amd64
  elif [[ "$(uname)" == "Linux" ]]; then
    curl -Lo "${bin}/kind" https://github.com/kubernetes-sigs/kind/releases/download/0.1.0/kind-linux-amd64
  else
    echo "unsupported platform $(uname)"
    exit 1
  fi
else
  echo "Found existing copy of kind, skipping download."
fi
chmod +x "${bin}/kind"

echo "+++ Fetching 'kubectl'"
if [[ ! -f "${bin}/kubectl" ]]; then
  if [[ "$(uname)" == "Darwin" ]]; then
    curl -Lo "${bin}/kubectl" https://storage.googleapis.com/kubernetes-release/release/v1.13.2/bin/darwin/amd64/kubectl
  elif [[ "$(uname)" == "Linux" ]]; then
    curl -Lo "${bin}/kubectl" https://storage.googleapis.com/kubernetes-release/release/v1.13.2/bin/linux/amd64/kubectl
  else
    echo "unsupported platform $(uname)"
    exit 1
  fi
else
  echo "Found existing copy of kubectl, skipping download."
fi
chmod +x "${bin}/kubectl"

echo "+++ Grabbed tools"
export PATH="${bin}:$PATH"

unset KUBECONFIG
kind delete cluster --name venafi > /dev/null 2>&1 || true

echo "+++ Creating local Kubernetes cluster..."
CLUSTER_NAME="venafi"
if ! kind create cluster --image kindest/node:v1.13.2 --name "$CLUSTER_NAME"; then
    echo "Creating Kubernetes cluster named $CLUSTER_NAME failed."
    echo "If the error above complains that a docker container already exists,"
    echo "please run '${bin}/kind delete cluster --name $CLUSTER_NAME'"
    exit 1
fi
echo "+++ Created local Kubernetes cluster"

export KUBECONFIG="$(kind get kubeconfig-path --name "$CLUSTER_NAME")"
echo "+++ Using ${KUBECONFIG} to talk to local Kubernetes cluster"

echo "+++ Verifying kubernetes apiserver is available"
kubectl get nodes

echo "+++ Deploying cert-manager"
kubectl apply -f "${SCRIPT_ROOT}/cert-manager.yaml"

echo
echo
echo -e "\e[32mAll components have been deployed!"
echo
echo -e "\e[32mPlease run the following command to make 'kubectl' work:"
echo
echo -e "\texport KUBECONFIG=$(kind get kubeconfig-path --name "$CLUSTER_NAME")"
echo
