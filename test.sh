#!/usr/bin/env bash

set -e

CONTAINER_TAG=htc-notebook-test

docker build -t ${CONTAINER_TAG} --file notebooks/htc-minimal-notebook/Dockerfile .
docker run -it --rm ${CONTAINER_TAG} bash
