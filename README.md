# ZCS Python docker images

Docker images used for ZCS Python applications.

Licensed under the [MIT License](LICENSE).

Supported python versions:

| Version | Debian base |
|---------|-------------|
| `3.11`  | `bookworm`  |
| `3.12`  | `bookworm`  |
| `3.13`  | `trixie`    |
| `3.14`  | `trixie`    |

Note: Python 3.11 and 3.12 are based on Debian Bookworm (stable). Python 3.13 and 3.14 are based on Debian Trixie (testing), which is required because the official `python:3.13-slim-bookworm` and `python:3.14-slim-bookworm` images are not available upstream.

Supported torch versions:

- `2.4.0`
- `2.4.1`
- `2.5.0`
- `2.5.1`
- `2.6.0`
- `2.7.0`
- `2.8.0`
- `2.9.0`
- `2.9.1`

Supported platforms:

- `linux/amd64`
- `linux/arm64`

## Image variants

ZCS Python docker images are available in four flavours:

- `base`: base image, mainly used by other stages
- `dev`: image for local development
- `dist`: image used for application distribution (currently identical to `base`; naming is kept for standardization)
- `torch-cpu`: image for distributing the final application with torch-cpu library

Notes:

- The `dist` image is currently equivalent to `base`; the separate tag is preserved to keep image naming conventions consistent across pipelines.

## Why these image variants

### Non-root default user (`base` / `dist`)

Running Python applications as a non-root user is a safer default for production workloads.

Benefits:

- Reduces container breakout impact, because processes do not run with root privileges.
- Prevents accidental writes to protected system locations.
- Aligns with Kubernetes and platform security policies that discourage or block root containers.
- Improves day-2 operations by making file ownership and runtime behavior more predictable.

How to use `dist`:

- Use `dist` for deployable application images.
- Keep `dist` in CI/CD pipelines even if it is currently equivalent to `base`, so naming remains consistent as the platform evolves.
- Build application layers on top of `dist` and keep runtime as the default non-root user.

### Host user mapping (`dev`)

The `dev` image includes `fix-perm.sh` to remap container UID/GID to the host user during build.

Benefits:

- Files created from the container are owned by the host developer user, not by root or an unexpected UID.
- Prevents permission conflicts in bind-mounted source directories.
- Preserves repository integrity by avoiding ownership drift that can break local tooling.
- Makes local development smoother across Linux hosts and CI runners with different user IDs.

### Preinstalled PyTorch (`torch-cpu`)

The `torch-cpu` image provides a ready-to-use runtime with PyTorch already installed.

Benefits:

- Faster application builds due to reduced dependency installation work.
- Better reproducibility when the PyTorch version is pinned in the image tag.
- Fewer network-related build failures in downstream projects.
- Simpler application Dockerfiles for ML services that always require PyTorch.

## Example usage

### Docker image for local development

Use the `dev` image when you want a local environment that behaves like your host machine from a file ownership perspective.

Why this matters in practice:

- Source files generated inside the container remain writable from your host user.
- Git operations on bind-mounted repositories avoid permission issues.
- Teams with different host UID/GID values can still use the same Dockerfile pattern.

The following Dockerfile snippet maps container user/group IDs to your host IDs during build:

```docker
FROM zcscompany/python:3.11-dev AS dev

ARG FIX_UID
ARG FIX_GID

USER 0
RUN /fix-perm.sh

# Run as normal user
USER bob
```

Build command:

```bash
docker build --build-arg FIX_UID="$(id -u)" --build-arg FIX_GID="$(id -g)" .
```

What happens during build:

- `FIX_UID` and `FIX_GID` are set from your current host user.
- `/fix-perm.sh` updates container user/group IDs to match the host values.
- The final image still runs as non-root, but with host-compatible ownership.

### Docker image for target application with torch-cpu library

Use this image when your runtime always requires PyTorch CPU support and you want to avoid reinstalling it in every downstream build.

Typical scenarios:

- ML inference services running on CPU-only nodes.
- Batch workloads where startup/build time should be minimized.
- CI pipelines where deterministic dependency layers improve reliability.

Dockerfile definition:

```docker
FROM zcscompany/python:3.11-torch-cpu-2.4.0

# Copy application requirement file
COPY --chown=${DOCKER_USER}:${DOCKER_GROUP} app/requirements.txt .

# Install app requirements
RUN pip install --user --no-cache-dir --disable-pip-version-check -r requirements.txt

# Copy application code
COPY --chown=${DOCKER_USER}:${DOCKER_GROUP} app/ .

# Run application
CMD ["python", "app.py"]
```

Notes:

- Keep the `torch-cpu` tag version explicit to guarantee reproducible environments.
- Install only application-specific requirements in child images.

### Docker image for target application

Use `dist` as the default base for deployable Python applications that do not need preinstalled PyTorch.

Why use this variant:

- Consistent naming in CI/CD (`*-dist` tags) across projects and stages.
- Non-root runtime by default for safer production deployments.
- Clean separation between development (`dev`) and deployment (`dist`) concerns.

```docker
FROM zcscompany/python:3.11-dist

# Copy application requirement file
COPY --chown=${DOCKER_USER}:${DOCKER_GROUP} app/requirements.txt .

# Install app requirements
RUN pip install --user --no-cache-dir --disable-pip-version-check -r requirements.txt

# Copy application code
COPY --chown=${DOCKER_USER}:${DOCKER_GROUP} app/ .

# Run application
CMD ["python", "app.py"]
```

Even though `dist` is currently equivalent to `base`, keeping `dist` in application Dockerfiles is recommended so future image specialization can be adopted without changing downstream naming conventions.

## Docker hub repository

The images in this repository are published to Docker Hub and versioned by tag.

Docker Hub page:

https://hub.docker.com/r/zcscompany/python

Refer to the Docker Hub page for the complete and up-to-date list of available image tags, as not all version combinations listed in this README may have a published image.

In most cases you can use these images directly in your application Dockerfiles (for example `FROM zcscompany/python:3.11-dist`) without rebuilding this repository locally.

This is useful when you want:

- Faster CI pipelines, because base images are already prebuilt.
- Consistent environments across teams and projects.
- Simpler onboarding, since developers can pull and use images immediately.

Example commands:

```bash
docker pull zcscompany/python:3.11-dist
docker run --rm -it zcscompany/python:3.11-dist python --version
```


## Support

[Claudio Cavina](mailto:c.cavina@zcscompany.com)  
[Michele Mondelli](mailto:m.mondelli@zcscompany.com)
