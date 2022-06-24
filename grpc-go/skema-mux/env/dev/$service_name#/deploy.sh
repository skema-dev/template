#!/bin/bash

function deploy() {
  kind load docker-image dev/{{.ProtocolServiceNameLower}}:latest

  kubectl create -f deploy.yaml
  curl http://localhost:30002/api/healthcheck
}

deploy
