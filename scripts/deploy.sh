#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Apply cluster setttings ..."
kubectl apply -k ${SCRIPT_DIR}/../deployments/cluster
echo

echo "Deploy kubedoom ..."
kubectl apply -k ${SCRIPT_DIR}/../deployments/kubedoom
echo
echo "Deploy score ..."
kubectl apply -k ${SCRIPT_DIR}/../deployments/score
echo
echo "Deploy monsters ..."
kubectl apply -k ${SCRIPT_DIR}/../assignment/monster
echo

kubectl rollout status deployment -n kubedoom kubedoom --timeout=90s
kubectl rollout status deployment -n score score --timeout=90s
