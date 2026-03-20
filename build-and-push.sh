#!/bin/bash

PUSH="--push"

set -eux 

docker buildx create --name container --driver=docker-container default || true

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target base -t zcscompany/python:3.11-base .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target dev -t zcscompany/python:3.11-dev .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target dist -t zcscompany/python:3.11-dist .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target base --build-arg PYTHON_VERSION=3.12 -t zcscompany/python:3.12-base .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target dev --build-arg PYTHON_VERSION=3.12 -t zcscompany/python:3.12-dev .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target dist --build-arg PYTHON_VERSION=3.12 -t zcscompany/python:3.12-dist .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg TORCH_VERSION=2.4.0 -t zcscompany/python:3.11-torch-cpu-2.4.0 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg TORCH_VERSION=2.4.1 -t zcscompany/python:3.11-torch-cpu-2.4.1 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg TORCH_VERSION=2.5.0 -t zcscompany/python:3.11-torch-cpu-2.5.0 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg TORCH_VERSION=2.5.1 -t zcscompany/python:3.11-torch-cpu-2.5.1 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg TORCH_VERSION=2.6.0 -t zcscompany/python:3.11-torch-cpu-2.6.0 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg TORCH_VERSION=2.7.0 -t zcscompany/python:3.11-torch-cpu-2.7.0 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg PYTHON_VERSION=3.12 --build-arg TORCH_VERSION=2.4.0 -t zcscompany/python:3.12-torch-cpu-2.4.0 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg PYTHON_VERSION=3.12 --build-arg TORCH_VERSION=2.4.1 -t zcscompany/python:3.12-torch-cpu-2.4.1 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg PYTHON_VERSION=3.12 --build-arg TORCH_VERSION=2.5.0 -t zcscompany/python:3.12-torch-cpu-2.5.0 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg PYTHON_VERSION=3.12 --build-arg TORCH_VERSION=2.5.1 -t zcscompany/python:3.12-torch-cpu-2.5.1 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg PYTHON_VERSION=3.12 --build-arg TORCH_VERSION=2.6.0 -t zcscompany/python:3.12-torch-cpu-2.6.0 .

docker buildx build --platform linux/amd64,linux/arm64 --sbom=true --provenance=true --builder=container --pull ${PUSH} --target torch-cpu --build-arg PYTHON_VERSION=3.12 --build-arg TORCH_VERSION=2.7.0 -t zcscompany/python:3.12-torch-cpu-2.7.0 .

docker buildx stop container
