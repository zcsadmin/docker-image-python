#!/bin/bash

PUSH="--push"

set -eux 

docker buildx create --name container --driver=docker-container default || true

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target base --build-arg PYTHON_VERSION=3.14 -t zcscompany/python:3.14-base .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target dev --build-arg PYTHON_VERSION=3.14 -t zcscompany/python:3.14-dev .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target base --build-arg PYTHON_VERSION=3.14 -t zcscompany/python:3.14-dist .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg PYTHON_VERSION=3.14 --build-arg TORCH_VERSION=2.9.0 -t zcscompany/python:3.14-torch-cpu-2.9.0 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg PYTHON_VERSION=3.14 --build-arg TORCH_VERSION=2.9.1 -t zcscompany/python:3.14-torch-cpu-2.9.1 .

docker buildx stop container
