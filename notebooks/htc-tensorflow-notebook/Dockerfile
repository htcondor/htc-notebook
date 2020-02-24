########################
# Dockerfile to make image spawned by CHTC Jupyterhub that
# launches a personal HTCondor instance upon spawning a
# notebook.  Designed to be used with SystemUserSpawner in mind.
# Author: Todd Tannenbaum <tannenba@cs.wisc.edu>
#
# Copyright (C) HTCondor Team, Computer Sciences Dept, Univ of Wisconsin-Madison
# Distributed under terms of the Apache Licence, Version 2.0.

FROM jupyter/tensorflow-notebook:latest

# metadata
LABEL maintainer="chtc@cs.wisc.edu"

# select HTCondor release series (first two digits only!)
ARG HTCONDOR_VERSION=8.9

# these are really from the base image, but ARG is not passed to child builds
# so we need to repeat them here if we want to use them
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

# default to jupyter lab
ENV JUPYTER_ENABLE_LAB=1

# install HTCondor, and a few other convenience tools
USER root
RUN apt-get update -qq \
 && apt-get install -qq gnupg vim less git man \
 && wget -qO - https://research.cs.wisc.edu/htcondor/ubuntu/HTCondor-Release.gpg.key | apt-key add - \
 && echo "deb  http://research.cs.wisc.edu/htcondor/ubuntu/${HTCONDOR_VERSION}/bionic bionic contrib" >> /etc/apt/sources.list \
 && apt-get update -qq \
 && apt-get install -qq htcondor \
 && apt-get clean -qq \
 && rm -rf /var/lib/apt/lists/*

# install HTCondor Python bindings, HTChirp, and HTMap
USER $NB_UID
RUN pip install --no-cache-dir htcondor htchirp htmap

# set up environment variable hooks for HTMap settings
# todo: once HTMap can decide the delivery method itself, remove it from here!
# todo: embed image name so HTMap can use the same image for exec
ENV HTMAP_DELIVERY_METHOD="assume"

# add an entrypoint script that starts HTCondor when the container starts
COPY --chown=jovyan:100 entrypoint.sh /.entrypoint.sh
RUN chmod +x /.entrypoint.sh
ENTRYPOINT ["tini", "-g", "--", "/.entrypoint.sh"]
CMD ["start-notebook.sh"]

# add an optimized HTCondor config
COPY --chown=jovyan:100 condor_config.local /etc/condor/condor_config.local
