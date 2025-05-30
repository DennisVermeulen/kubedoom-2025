#!/bin/sh

kind delete cluster --name kubedoom
sleep 5

docker kill kind-registry
sleep 2

docker system prune -a