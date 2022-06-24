#!/bin/bash

function deploy() {
  kind load docker-image dev/{{.ProtocolServiceNameLower}}:latest

  kubectl create -f deploy.yaml
  echo "wait 10 seconds for service startup"
  sleep 10
  echo "curl http://localhost/{{.ProtocolServiceNameLower}}/api/healthcheck"
  curl http://localhost/{{.ProtocolServiceNameLower}}/api/healthcheck
}

deploy
