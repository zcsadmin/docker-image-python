#
# Base image
#
FROM python:3.11-slim-bookworm AS base

ARG DOCKER_USER=bob
ARG DOCKER_GROUP=bob

# Add normal user that will use the container
RUN set -ex; addgroup --gid 1000 ${DOCKER_GROUP} && \
    adduser --ingroup ${DOCKER_GROUP} --uid 1000 --disabled-password ${DOCKER_USER} 

# Create app directory
RUN mkdir /app && \
    chown -R ${DOCKER_USER}:${DOCKER_GROUP} /app

# Set working directory
WORKDIR /app

# Add pip installed binary directory to PATH
ENV PATH="/home/${DOCKER_USER}/.local/bin:${PATH}"

# Run as normal user
USER ${DOCKER_USER}

#
# Dev image
#
FROM base AS dev

# Add fix-perm.sh script to image
USER 0
COPY ./fix-perm.sh /fix-perm.sh
RUN chmod +x /fix-perm.sh

USER ${DOCKER_USER}

# Set entrypoint so the container will run without doing anything
ENTRYPOINT ["/bin/sleep", "infinity"]

FROM base AS dist

#
# Image with torch-cpu library installed
#
FROM base AS torch-cpu

# Install torch 2.4.0 cpu
RUN pip install --prefix "/home/${DOCKER_USER}/.local" --no-cache-dir --disable-pip-version-check torch==2.4.0 --index-url https://download.pytorch.org/whl/cpu

