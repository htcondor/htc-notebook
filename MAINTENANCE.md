# Maintenance

## What's Going On?

This repository contains the Dockerfiles that produce the `htc-*-notebook` Docker images.
The actual files are produced from a template and built automatically by Docker Hub.

## How Does it Work?

Each `htc-*-notebook` is based (i.e., `FROM`) on a correspondingly-named
[Jupyter Docker Stack](https://jupyter-docker-stacks.readthedocs.io/en/latest/)
image.
These base images are listed in `BASE_IMAGES.txt`

The Python script `make.py` takes a Dockerfile template stored in `template`
(along with support files) and produces a directory for each `htc-*-notebook`
under `notebooks`. **Do not manually edit anything under `notebooks`!**
Everything in there will be clobbered and re-written by `make.py`.

## Build Infrastructure

The actual images are built and distributed via [Docker Hub](https://hub.docker.com/).

The builds are automatically triggered whenever something is pushed to master.
Development work should therefore always happen on a branch and then be merged
into master when ready.

Docker Hub automatically pushes the newly-built image with the `latest` tag.
For posterity, each build also has a post-push hook (`template/hooks/post_push`)
that pushes a tag based on the first 12 characters of the commit hash.

## How to Make Changes

If you want to change the produced Docker images, you need to either
edit the template or edit `make.py`. Hopefully, most changes can be made 
in the template instead of `make.py`.

The `notebooks` directory **should** be in source control, and you **should** push
any changes made to it
(i.e., run `make.py`, then commit the changes in `notebooks/` as well as any other changes).
**There is currently no automatic check that the current state of `notebooks/`
is what would be produced by the current `make.py` and `template/` - be vigilant!**

## How to Add a New Image

1. Add a new line to `BASE_IMAGES.txt` containing the full `repo/image:tag` of 
   the base image to build on top of.
2. Run `python3 make.py`. Confirm that a new directory has appeared in `notebooks/`
   with the desired name, containing a Dockerfile with the desired base image in it.
3. On Docker Hub, in the `htcondor` organization (you will need to be added to it),
   create a new repository with the desired name.
4. Go to the new repository and click on the "Builds" tab, then "Configure Automated Builds"
   in the top-right corner.
5. Set the "Source Repository" to `htc-notebook`.
6. If this image should be updated whenever the underlying `FROM` image is updated,
   enable "Repository Links > Enabled for Base Image".
7. Add a "Build Rule" with Source `master`, Docker Tag `latest`, 
   Dockerfile location `Dockerfile`, and build Build Context `/notebooks/<name>/`,
   where `<name>` is the name of the directory containing the new Dockerfile.
   Leave Autobuild and Build Caching enabled.
8. Click "Save and Build".

The new image should then be built and pushed by Docker Hub.
Their build infrastructure is quite slow 
(as of the time of writing, it typically takes at least 20 minutes to finish).
