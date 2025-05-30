#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl delete ns kubedoom --force
kubectl delete ns score --force
kubectl delete ns monster --force

sleep 10

${SCRIPT_DIR}/deploy.sh

echo "Reset Finished!"
echo