# AGENTS.md

This repo builds and publishes `zcscompany/python` Docker images to Docker Hub (multi-arch: `linux/amd64` + `linux/arm64`). There is no application code, tests, or lint — the "build system" is one `Dockerfile` plus shell scripts. Verification = a successful `docker buildx build` (optionally followed by `docker run --rm <tag> python --version`).

## Image variants

Single `Dockerfile` with four targets:

- `base` — base image
- `dev` — `base` + `/fix-perm.sh` (host UID/GID remapping), entrypoint `sleep infinity`
- `dist` — currently identical to `base`; the separate tag exists purely for naming consistency in downstream pipelines. Do not "simplify" it away.
- `torch-cpu` — `base` + PyTorch installed from `https://download.pytorch.org/whl/cpu`

Build args: `PYTHON_VERSION` (default 3.11), `DEBIAN_VERSION` (default `bookworm`), `TORCH_VERSION` (required for `torch-cpu`), `DOCKER_USER`/`DOCKER_GROUP` (default `bob`, uid/gid 1000).

Tag scheme: `zcscompany/python:<python>-<variant>` and `zcscompany/python:<python>-torch-cpu-<torch>`.

## Build / push commands

- `bash build-and-push.sh` — 3.11 + 3.12 (bookworm)
- `bash build-and-push-3_13.sh` — 3.13 (trixie)
- `bash build-and-push-3_14.sh` — 3.14 (trixie)

**These scripts hardcode `PUSH="--push"`: running them as-is pushes every tag to Docker Hub.** For local test builds, remove `--push` from the commands (or drop the flag in a copy) instead of running the scripts unchanged.

Single-target local build:

```bash
docker buildx build --target dist -t zcscompany/python:3.11-dist .
docker buildx build --target torch-cpu --build-arg TORCH_VERSION=2.9.1 -t zcscompany/python:3.11-torch-cpu-2.9.1 .
```

Multi-arch builds need a buildx builder with the `docker-container` driver; the scripts create one named `container` and stop it at the end.

## Base image matrix (do not guess)

- 3.11, 3.12 → `bookworm`; 3.13, 3.14 → `trixie` (no upstream `slim-bookworm` tags for 3.13/3.14).
- Torch versions per Python are fixed by the build scripts — they are the source of truth. The README's torch list is broader and includes combinations with no published image.

## CI

Two scheduled workflows (every 7 days, plus manual dispatch) rebuild the 3.13 and 3.14 images only when the upstream digest of `python:3.1X-slim-trixie` (checked via `skopeo`) changes. On change the workflow logs into Docker Hub (secrets), runs the matching build script, and commits the new digest to `.github/state/python-3.1X-slim-trixie.digest`. There are no workflows for 3.11/3.12.

## Downstream usage quirks

- Runtime user is non-root `bob` (uid/gid 1000), `WORKDIR /app`, and `/home/bob/.local/bin` is on `PATH`. Downstream images should `pip install --user` (torch-cpu already installs torch with `--prefix /home/bob/.local`).
- `dev` images: downstream Dockerfiles pass `--build-arg FIX_UID=$(id -u) --build-arg FIX_GID=$(id -g)`, then `USER 0; RUN /fix-perm.sh` to remap container ownership to the host user (example in README).
