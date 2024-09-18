#!/bin/bash

set -eux 

docker buildx create --name container --driver=docker-container default || true

docker buildx build --sbom=true --provenance=true --builder=container --pull --push --target base -t zcscompany/python:3.11-base .

docker buildx build --sbom=true --provenance=true --builder=container --pull --push --target dev -t zcscompany/python:3.11-dev .

docker buildx build --sbom=true --provenance=true --builder=container --pull --push --target base -t zcscompany/python:3.11-dist .

docker buildx build --sbom=true --provenance=true --builder=container --pull --push --target torch-cpu -t zcscompany/python:3.11-torch-cpu-2.4.0 .

docker buildx stop container
