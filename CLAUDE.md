# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Kubernetes Version
- This project uses Kind with Kubernetes v1.33.0

## Build/Run Commands
- Setup game: `./scripts/persist-images-local.sh` then `./scripts/spinup-registry-local.sh`
- Start cluster: `./scripts/spinup-cluster-deploy.sh`
- Play game: `cd assignment && ./start.sh`
- Reset game: `./scripts/reset.sh` (soft) or `./scripts/hard-reset.sh` (hard)
- Full cleanup: `./scripts/full-cleanup.sh`

## Code Guidelines
- YAML: 2-space indentation
- Python: Follow PEP 8 style guidelines
- Shell scripts: Standard Bash conventions and syntax
- Kubernetes manifests: Consistent structure with metadata/spec sections
- Comments: Keep minimal and descriptive
- Error handling: In Python, use try/except blocks and appropriate exit codes

## Project Structure
- Kubernetes-based game using KubeDoom
- 5-minute timer to fix deployment and shoot demons for points
- Key components in containers/, deployments/, assignment/, and scripts/
- Scores are saved to a persistent CSV file via the score service
- Score data is stored in a PersistentVolume to survive pod/cluster restarts
- View scores history at http://localhost:32001/scores/view

## Score System
- The score service (/deployments/score/) maintains player scores
- Scores are stored in a CSV file in a persistent volume
- When a game ends, score data is written to /data/scores.csv
- A web interface at http://localhost:32001/scores/view displays all historical scores