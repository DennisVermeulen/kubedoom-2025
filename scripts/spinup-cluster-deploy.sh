#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# define registry name
reg_name='kind-registry'
reg_cluster_port='6200'

# start kind cluster
kind create cluster --config=${SCRIPT_DIR}/cluster.yaml
echo

# connect the registry to the cluster network if not already connected
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = 'null' ]; then
  docker network connect "kind" "${reg_name}"
  echo "Registry endpoint in the cluster: ${reg_name}:${reg_cluster_port}"
  echo
fi

# start all deployments
${SCRIPT_DIR}/deploy.sh