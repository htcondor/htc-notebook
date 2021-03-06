# Maintenance

## What's Going On?

This repository contains the Dockerfiles that produce the `htc-*-notebook` Docker images.
The actual files are produced from a template and built automatically by Docker Hub.

## How Does it Work?

Each `htc-*-notebook` is based on (i.e., `FROM`) a correspondingly-named
[Jupyter Docker Stack](https://jupyter-docker-stacks.readthedocs.io/en/latest/)
image.
These base images are listed in `BASE_IMAGES.txt`

The Python script `make.py` takes a Dockerfile template stored in `template`
(along with support files) and produces a directory for each `htc-*-notebook`
under `notebooks`. 

**Do not manually edit anything under `notebooks`!**
Everything in there will be clobbered and re-written by `make.py`.

## Build Infrastructure

The actual images are built and distributed via [Docker Hub](https://hub.docker.com/).

The builds are automatically triggered whenever something is pushed to master.
Development work should therefore always happen on a branch and then be merged
into master when ready.

Docker Hub automatically pushes the newly-built image with the `latest` tag.
We also has a post-push hook (`template/hooks/post_push`)
that pushes a tag based on the date.

## How to Make Changes

If you want to change the produced Docker images, you need to either
edit the template or edit `make.py`. Hopefully, most changes can be made 
in the template instead of `make.py`. `make.py` implements a very basic and
not very generic templating engine.

The `notebooks` directory **should** be in source control, and you **should** push
any changes made to it
(i.e., run `make.py`, then commit the changes in `notebooks/` as well as any other changes).
**There is currently no automatic check that the current state of `notebooks/`
is what would be produced by the current `make.py` and `template/` - be vigilant!**

> Because our images are based on the Jupyter Docker stack images,
> it is entirely possible that they will make changes which break us.
> Be prepared for breaking changes to come from upstream unexpectedly.

## How to Add a New Base Image

Adding the new base image:

1. Add a new line to `BASE_IMAGES.txt` containing the full `repo/image:tag` of 
   the base image to build on top of.
1. Run `python3 make.py`. Confirm that a new directory has appeared in `notebooks/`
   with the desired name, containing a Dockerfile with the desired base image in it.

Enabling the automated Docker Hub build:

1. On Docker Hub, in the `htcondor` organization (you will need to be added to it),
   create a new repository with the desired name.
1. Go to the new repository and click on the "Builds" tab, then "Configure Automated Builds"
   in the top-right corner.
1. Set the "Source Repository" to `htc-notebook`.
1. If this image should be updated whenever the underlying `FROM` image is updated,
   enable "Repository Links > Enabled for Base Image". This is useful for automatically
   rebuilding when on the `latest` tag of the base image is updated, so that
   we can track improvements in the Jupyter Docker stacks without much work on our end.
1. Add a "Build Rule" with Source `master`, Docker Tag `latest`, 
   Dockerfile location `Dockerfile`, and build Build Context `/notebooks/<name>/`,
   where `<name>` is the name of the directory containing the new Dockerfile.
   Leave Autobuild and Build Caching enabled.
1. Click "Save and Build".

The new image should then be built and pushed by Docker Hub.
Their build infrastructure is quite slow 
(as of the time of writing, it typically takes at least 20 minutes to finish
each build, and the builds are sequential).
