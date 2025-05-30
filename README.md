# KubeCon + CloudNativeCon Europe 2025

## TL;DR

Setup game

```shell
# 1) Persist images (online)
./scripts/persist-images-local.sh 
# 2) Spin up local registry (offline)
./scripts/spinup-registry-local.sh
# 3) Run cluster and start deployment
./scripts/spinup-cluster-deploy.sh
# Play Game
cd assignment
./start.sh

```

Cleanups

```shell
# Reset game
./scripts/reset.sh
./scripts/hard-reset.sh
# Cleanup setup
./scripts/full-cleanup.sh # Warning: need online access to setup game again
```

## Preparation

If you starting from scratch, two steps are needed as preparation before you can start the cluster:
1) Pulling and persisting the images (while connected to the internet)
2) Spin up a local registry and fill it with the needed images (can be done offline)

---
### 1) Persist images (online)

Persist the needed container images by running the below **run command**. 
- Needed images are specified in `./scripts/persist-images-local.sh` 
- Images are saved in a tar/gz format in `./registry/image_archives`.

Run command:
```shell
./scripts/persist-images-local.sh 
```
This will fill the `./registry/image_archives/` directory:
```shell
❯ ls -1 ./registry/image-archives/
ascii-image-converter_cinq-kubecon-2023.tar.gz
kind-node_v1.33.0_cinq-kubedoom-2025.tar.gz
doom_cinq-kubedoom-2025.tar.gz
lookinthelogs_cinq-kubedoom-2025.tar.gz
registry_2.tar.gz
score_cinq-kubedoom-2025.tar.gz
```

---
### 2) Spin up local registry (offline)

A local registry is needed for the cluster. The local registry is started with the below **run command**.
- Image `registry:2` is used
- Imaged archives are loaded from `./registry/image_archives` and pushed to the local registry (`localhost:5001`)

Run command:
```shell
./scripts/spinup-registry-local.sh
```

---
# Running stuff (offline)


## Run cluster and start deployment
To run the cluster and start the deployment, run this:
```shell
./scripts/spinup-cluster-deploy.sh 
```

## Play Game

start begin screen

```shell
cd assignment
./start.sh

```

## Reset
Removes namespaces:
- kubedoom 
- score
- monster
and starts `./scripts/spinup-cluster-deploy.sh`.
```shell
./scripts/reset.sh
```

### Hard reset
Removes the cluster and starts `./scripts/spinup-cluster-deploy.sh`.
```shell
./scripts/hard-reset.sh
```

# Clean up

Warning: need online access to setup game again.

When done, run a full clean up:
- delete kind cluster
- stop local registry
- prune all (networks, images, stopped containers, etc.)

```shell
./scripts/full-cleanup.sh
```

## Score Persistence

Game scores are saved directly to your local filesystem. You can view your score history at:
```
http://localhost:32001/scores/view
```

The scores are stored in a CSV file (`data/scores.csv`) and persist between game sessions, even when you reset the game or restart the cluster. The data directory is mounted into the Kubernetes cluster, so scores are immediately accessible on your MacBook.

# Reference documentation

Some references used to develop this can be found in the [reference documentation](REFERENCE_DOCUMENTATION.md)

## ToDO
game-timer.sh aanpassen naar 300

Aanpassen in cluster.yaml:
    extraMounts:
      - hostPath: /data
        containerPath: /cinq-kubedoom-2025/data
en in deploment van score
      volumes:
        - name: score-data
          hostPath:
            path: /cinq-kubedoom-2025/data
            type: DirectoryOrCreate