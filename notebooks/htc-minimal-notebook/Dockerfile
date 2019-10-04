########################
# Dockerfile to make image spawned by CHTC Jupyterhub that
# launches a personal HTCondor instance upon spawning a
# notebook.  Designed to be used with SystemUserSpawner in mind.
# Author: Todd Tannenbaum <tannenba@cs.wisc.edu>
#
# Copyright (C) HTCondor Team, Computer Sciences Dept, Univ of Wisconsin-Madison
# Distributed under terms of the Apache Licence, Version 2.0.
#

FROM jupyter/minimal-notebook:latest

# metadata

LABEL maintainer="chtc@cs.wisc.edu"

# config

ENV HTMAP_DOCKER_IMAGE="jupyter/minimal-notebook:latest" \
    HTMAP_DELIVERY_METHOD="assume" \
    DEBIAN_FRONTEND=noninteractive
ARG HTCONDOR_VERSION=8.9
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

# install HTCondor, and a few other convenience tools
USER root
RUN apt-get update -qq \
 && apt-get install -qq gnupg vim less git \
 && wget -qO - https://research.cs.wisc.edu/htcondor/ubuntu/HTCondor-Release.gpg.key | apt-key add - \
 && echo "deb  http://research.cs.wisc.edu/htcondor/ubuntu/${HTCONDOR_VERSION}/bionic bionic contrib" >> /etc/apt/sources.list \
 && apt-get update && apt-get -qq install htcondor \
 && apt-get clean -qq \
 && rm -rf /var/lib/apt/lists/*

# add the script that starts HTCondor before the notebook runs
COPY start-htcondor.sh /usr/./local/bin/before-notebook.d/

# add an optimized HTCondor config
COPY --chown=jovyan:0 condor_config.local /etc/condor/condor_config.local

# install HTCondor Python bindings, HTChirp, and HTMap
USER $NB_UID
RUN pip install --no-cache htcondor htchirp htmap
