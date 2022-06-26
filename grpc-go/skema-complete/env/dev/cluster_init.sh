#!/bin/bash

function init() {
  echo "create dev cluster"
  kind create cluster --config kind-cluster.yaml

  echo "install ingress-nginx"
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
  kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

  echo "setup kubernetes dashboard"
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
  kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
  kubectl apply -f k8s-secret.yaml
}

init
