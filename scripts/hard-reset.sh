#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kind delete cluster --name kubedoom

sleep 10

${SCRIPT_DIR}/spinup-cluster-deploy.sh