# High-Throughput Computing Notebooks

This repository contains the source Dockerfiles for 
CHTC's High-Throughput Computing Notebooks (HTC Notebooks).
Each notebook is based on one of the 
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/),
as specified by their names.

An HTC Notebook image contains both Jupyter Lab and a 
"personal" HTCondor that can run jobs locally,
making it ideal for testing workflows on local resources before scaling out
to an entire HTCondor pool.

HTC Notebooks can also be configured as part of a Jupyter Hub which connects 
users to a larger HTCondor pool.

See the 
[Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/#table-of-contents)
documentation for more general information on using these images
(as well as tips and tricks).


## Quick Start

To pull and run a pre-built HTC Notebook image from Docker Hub,
use a `docker run` command that looks like

```console
$ docker run -it --rm -p 8888:8888 htcondor/htc-scipy-notebook:latest
```

Replace `htc-scipy-notebook` with your preferred stack 
(see below for a full list),
and `latest` with your preferred tag.
The `latest` tag will always point at the most recent version of that stack, 
but 
[date-tagged previous versions](https://hub.docker.com/r/htcondor/htc-scipy-notebook/tags)
are available as well.

To bind-mount the current working directory into the container, add a `--mount`
option to your `docker run`:

```console
$ docker run -it --rm -p 8888:8888 --mount type=bind,source="$(pwd)",target=/home/jovyan/work htcondor/htc-scipy-notebook:latest
```

This will link the directory that you launch the container in to the path
`/home/jovyan/work` inside the container. Changes you make inside the
container will be reflected outside, and vice-versa.

If you don't want to run Jupyter Lab automatically and want (for example)
a `bash` shell instead, add `bash` to the end of the `docker run` command:

```console
$ docker run -it --rm -p 8888:8888 htcondor/htc-scipy-notebook:latest bash
```


## Available Images

A brief summary of what is available in each image is available below.
For more detailed information on the Jupyter parts of the image, see the 
[Jupyter Docker Stacks documentation](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#core-stacks).

In addition to what is described there, every image has a 
"personal" HTCondor pool running inside it, and includes the 
[HTCondor Python Bindings](https://htcondor.readthedocs.io/en/latest/apis/python-bindings/index.html)
and [HTMap](https://htmap.readthedocs.io/en/latest/).

- [`htc-base-notebook`](https://hub.docker.com/r/htcondor/htc-base-notebook) - This is the smallest useful container; this is often the best image to `FROM` for custom images. 
- [`htc-minimal-notebook`](https://hub.docker.com/r/htcondor/htc-minimal-notebook) - Adds useful command line tools like `git`, `emacs`, and `vim` to the `htc-base-notebook`.
- [`htc-scipy-notebook`](https://hub.docker.com/r/htcondor/htc-scipy-notebook) - Includes popular packages from the Scientific Python ecosystem like `scipy` and `matplotlib`.
- [`htc-r-notebook`](https://hub.docker.com/r/htcondor/htc-r-notebook) - Includes the R interpreter and popular tidyverse packages.
- [`htc-datascience-notebook`](https://hub.docker.com/r/htcondor/htc-datascience-notebook) - Includes everything in the `htc-scipy-notebook` and `htc-r-notebook`, as well as Julia.
- [`htc-tensorflow-notebook`](https://hub.docker.com/r/htcondor/htc-tensorflow-notebook) - Everything in `htc-scipy-notebook`, plus Tensorflow and Keras.
- [`htc-pyspark-notebook`](https://hub.docker.com/r/htcondor/htc-pyspark-notebook) - Everything in `htc-scipy-notebook`, plus Apache Spark.
- [`htc-all-spark-notebook`](https://hub.docker.com/r/htcondor/htc-all-spark-notebook) - Everything in `htc-pyspark-notebook`, plus R and Scala support for Apache Spark.


## Tips, Tricks, and Gotchas

If you are using a bind mount to access local files from inside the container,
you must not mount directly to `/home/jovyan`.
Instead, always use a subdirectory of `/home/jovyan`, like `/home/jovyan/work`.
(Bind-mounting directly to `/home/jovyan` breaks the HTCondor pool running inside the container).
