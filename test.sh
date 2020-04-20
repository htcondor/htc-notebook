#!/usr/bin/env bash

set -e

CONTAINER_TAG=htc-notebook-test

docker build -t ${CONTAINER_TAG} notebooks/htc-minimal-notebook
docker run -it --rm ${CONTAINER_TAG} bash
