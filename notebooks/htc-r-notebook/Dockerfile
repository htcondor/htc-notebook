########################
# Dockerfile to make image spawned by CHTC Jupyterhub that
# launches a personal HTCondor instance upon spawning a
# notebook.  Designed to be used with SystemUserSpawner in mind.
# Author: Todd Tannenbaum <tannenba@cs.wisc.edu>
#
# Copyright (C) HTCondor Team, Computer Sciences Dept, Univ of Wisconsin-Madison
# Distributed under terms of the Apache Licence, Version 2.0.

FROM jupyter/r-notebook:latest

# metadata
LABEL maintainer="chtc@cs.wisc.edu"

# select HTCondor release series (first two parts only!)
ARG HTCONDOR_VERSION=9.x

# default to jupyter lab
ENV JUPYTER_ENABLE_LAB=1

USER root

# add HTCondor config
COPY condor_config.local /etc/condor/condor_config.local

# add an entrypoint that starts HTCondor
COPY entrypoint.sh /.entrypoint.sh

# install HTCondor, and a few other convenience tools
# also fix permissions on the files copied above
RUN apt-get update -y \
 && apt-get install -y gnupg vim less git man \
 && wget -qO - https://research.cs.wisc.edu/htcondor/repo/keys/HTCondor-${HTCONDOR_VERSION}-Key | apt-key add - \
 && echo "deb  https://research.cs.wisc.edu/htcondor/repo/ubuntu/${HTCONDOR_VERSION} focal main" >> /etc/apt/sources.list \
 && apt-get update -y \
 && apt-get install -y htcondor \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/* \
 && chmod +x /.entrypoint.sh \
 && chown -R ${NB_UID}:${NB_GID} /home/${NB_USER}/.condor \
 && fix-permissions ${HOME}

USER $NB_UID:$NB_GID

# install HTCondor Python bindings, HTChirp, and HTMap
RUN pip install --no-cache-dir htcondor htchirp htmap

# set up environment variable hooks for HTMap settings
# todo: once HTMap can decide the delivery method itself, remove it from here!
# todo: embed image name so HTMap can use the same image for exec
ENV HTMAP_DELIVERY_METHOD="assume"

ENTRYPOINT ["tini", "-g", "--", "/.entrypoint.sh"]
CMD ["start-notebook.sh"]
