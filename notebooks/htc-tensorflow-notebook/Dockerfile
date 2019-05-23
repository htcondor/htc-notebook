########################
# Dockerfile to make image spawned by CHTC Jupyterhub that
# launches a personal HTCondor instance upon spawning a
# notebook.  Designed to be used with SystemUserSpawner in mind.
# Author: Todd Tannenbaum <tannenba@cs.wisc.edu>
#
# Copyright (C) HTCondor Team, Computer Sciences Dept, Univ of Wisconsin-Madison
# Distributed under terms of the Apache Licence, Version 2.0.
#

FROM jupyter/tensorflow-notebook:abdb27a6dfbb

# metadata

LABEL maintainer="chtc@cs.wisc.edu"

# config

ENV HTMAP_DOCKER_IMAGE="jupyter/tensorflow-notebook:abdb27a6dfbb"
ENV HTMAP_DELIVERY_METHOD="assume"
ARG JUPYTERHUB_VERSION=0.9.4
ARG HTCONDOR_VERSION=8.8
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

# actual build

USER root

# Install latest HTCondor native package, as well
# as HTCondor python bindings, htmap package, and
# a few handy things like vim, less.

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq \
 && apt-get install -qq gnupg vim less git \
 && wget -qO - https://research.cs.wisc.edu/htcondor/ubuntu/HTCondor-Release.gpg.key | apt-key add - \
 && echo "deb  http://research.cs.wisc.edu/htcondor/ubuntu/${HTCONDOR_VERSION}/bionic bionic contrib" >> /etc/apt/sources.list \
 && apt-get update && apt-get -qq install htcondor \
 && apt-get clean -qq \
 && rm -rf /var/lib/apt/lists/*


USER $NB_UID

# We want the end user to be able to conda install new
# packages without sudo.  To do this, we need to upgrade
# the version of Conda to avoid hitting this conda bug:
# https://github.com/conda/conda/issues/7267

RUN conda config --add channels conda-canary \
 && conda update -n base conda

USER root

COPY start-htcondor.sh /usr/./local/bin/before-notebook.d/
COPY condor_config.local /etc/condor/condor_config.local

RUN mkdir -p /usr/local/bin/before-notebook.d \
  && pip install --no-cache \
  jupyterhub==$JUPYTERHUB_VERSION \
  htcondor \
  htmap

USER $NB_UID
