#!/bin/bash

echo "your local kubernetes token is: "
echo $(kubectl get secret default-token -o jsonpath='{.data.token}' | base64 --decode)
echo "\nOpen URL for dashboard: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login"
kubectl proxy
