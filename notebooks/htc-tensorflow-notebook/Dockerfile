########################
# Dockerfile to make image spawned by CHTC Jupyterhub that
# launches a personal HTCondor instance upon spawning a
# notebook.  Designed to be used with SystemUserSpawner in mind.
# Author: Todd Tannenbaum <tannenba@cs.wisc.edu>
#
# Copyright (C) HTCondor Team, Computer Sciences Dept, Univ of Wisconsin-Madison
# Distributed under terms of the Apache Licence, Version 2.0.

FROM quay.io/jupyter/tensorflow-notebook:latest

# metadata
LABEL maintainer="chtc@cs.wisc.edu"

# select HTCondor release series (first two parts only!)
ARG REPO_VERSION=25.x

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
 && apt-get install -y apt-transport-https apt-utils curl git gnupg less man vim \
 && mkdir -p /etc/apt/keyrings \
 && . /etc/os-release \
 && curl -fsSL "https://htcss-downloads.chtc.wisc.edu/repo/keys/HTCondor-${REPO_VERSION}-Key" -o /etc/apt/keyrings/htcondor.asc \
 && curl -fsSL "https://htcss-downloads.chtc.wisc.edu/repo/$ID/htcondor-${REPO_VERSION}-${VERSION_CODENAME}.list" -o /etc/apt/sources.list.d/htcondor.list \
 && apt-get update -y \
 && apt-get install -y condor \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/* \
 && chmod +x /.entrypoint.sh \
 && chown -R ${NB_UID}:${NB_GID} /home/${NB_USER}/.condor \
 && fix-permissions ${HOME}

USER $NB_UID:$NB_GID

# install HTCondor Python bindings, HTChirp
RUN pip install --no-cache-dir htcondor htchirp

ENTRYPOINT ["tini", "-g", "--", "/.entrypoint.sh"]
CMD ["start-notebook.sh"]
