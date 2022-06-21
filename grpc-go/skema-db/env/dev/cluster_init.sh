#!/bin/bash

function init() {
  echo "create dev cluster"
  kind create cluster --config kind-cluster.yaml

  echo "setup kubernetes dashboard"
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
  kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
  kubectl apply -f k8s-secret.yaml
  echo "your local kubernetes token is: "
  echo $(kubectl get secret default-token -o jsonpath='{.data.token}' | base64 --decode)
  echo "Open URL for dashboard: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login"
}

init
