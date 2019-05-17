# High-Throughput Computing Notebooks

This repository contains the source Dockerfiles for 
CHTC's High-Throughput Computing Notebooks (HTC Notebook).
Each notebook is based on one of the [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks),
as specified by their names.

A HTC Notebook contains both a Jupyter Lab and a "personal" HTCondor that can run jobs locally.
It can also be configured as (for example) part of a Jupyter Hub which connects users to a larger HTCondor pool.

## Quick Start

To run one of the images, use a `docker run` command that looks like

```bash
docker run -p 8888:8888 htcondor/htc-scipy-notebook:latest
```

Replace `htc-scipy-notebook` with your preferred stack,
and `latest` with your preferred tag.

The `latest` tag will always point at the most recent version of that stack,
but SHA-tagged previous version are available as well.
