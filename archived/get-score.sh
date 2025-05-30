#!/bin/bash

echo "=========================================="
echo "Finding POD Environment variables"
POD_ENV=$(kubectl get pod payload-6d58f4c857-kctlv -o=jsonpath='{.spec.containers[0].env}')
echo "=========================================="
echo "Detected variables:"
echo $POD_ENV
echo "=========================================="

echo "Verifying EMAIL"
EMAIL=$(echo $POD_ENV | jq -e -r '.[]|select(.name == "EMAIL").value')
if [ $? -eq 1 ]; then
  echo "User did not set EMAIL"
  exit 1
fi
echo "Detected EMAIL: ${EMAIL}"

echo "Verifying USERNAME"
USERNAME=$(echo $POD_ENV | jq -e -r '.[]|select(.name == "USERNAME").value')
if [ $? -eq 1 ]; then
  echo "User did not set USERNAME"
  exit 1
fi
echo "Detected USERNAME: ${USERNAME}"

echo "User has set both EMAIL and USERNAME, getting Score!"

if [[ -f "./scores/${EMAIL}" ]]; then
  echo "We already have a score for that EMAIL!"
  exit 1
fi

kubectl port-forward -n score svc/score-service 8080:80 &
echo
if [ $? -ne 0 ]; then 
  echo "Could not connect to score app"
  exit 1
fi
sleep 1

curl localhost:8080/score -o scores/${EMAIL}

kill %1
echo