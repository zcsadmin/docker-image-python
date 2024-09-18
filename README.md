# ZCS Python docker images

Docker images used for ZCS Python applications.

## Example usage

ZCS Python docker images are available in three flavours:

- `base`: base image, mainly used by other stages
- `dev`: image for local development
- `dist`: image used for application distribution
- `torch-cpu`: image for distributing the final application with torch-cpu library

### Docker image for local development

The docker image for local development support permissions mapping between host user and docker user. 

Dockerfile definition to use `dev` image in local environment mapping the image `bob` user to host user:

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

### Docker image for target application with torch-cpu library

Dockerfile definition

```docker
FROM zcscompany/python:3.11-torch-cpu-2.4.0

# Copy application requirement file
COPY --chown=bob:bob app/requirements.txt .

# Install app requirements
RUN pip install --user --no-cache-dir --disable-pip-version-check -r requirements.txt

# Copy application code
COPY --chown=bob:bob app/ .

# Build and install the library
RUN python -m build && \
    pip install --user --no-cache-dir --disable-pip-version-check --editable .
```

### Docker image for target application

```docker
FROM zcscompany/python:3.11-dist

# Copy application requirement file
COPY --chown=bob:bob app/requirements.txt .

# Install app requirements
RUN pip install --user --no-cache-dir --disable-pip-version-check -r requirements.txt

# Copy application code
COPY --chown=bob:bob app/ .

# Build and install the library
RUN python -m build && \
    pip install --user --no-cache-dir --disable-pip-version-check --editable .
```

## Build images

### Base image

```bash
docker build --pull --target base -t zcscompany/python:3.11-base .
```

### Dev image

```bash
docker build --pull --target dev -t zcscompany/python:3.11-dev .
```

### Dist image

```bash
docker build --pull --target base -t zcscompany/python:3.11-dist .
```

### Torch-cpu image

```bash
docker build --pull --target torch-cpu -t zcscompany/python:3.11-torch-cpu-2.4.0 .
```

## Docker hub repository

https://hub.docker.com/r/zcscompany/python


## Support

[Madnesslab Team @ Zucchetti Centro Sistemi](mailto:madnesslab@zcscompany.com)
