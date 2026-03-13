#!/bin/bash
# Exit on any error
set -e

# Get rid of test image
docker image rm htc-notebook-test:latest || true

# Create and tag images
for i in $(<BASE_IMAGES.txt); do
    NAME=${i##*/}
    NAME=htc-${NAME%%:*}
    echo "======= $NAME ======="
    docker pull "$i"
    docker image ls "htcondor/${NAME}" --format '{{.Repository}}:{{.Tag}}' > "${NAME}.out"
    for IMAGE in $(<"${NAME}.out"); do
        docker image rm "${IMAGE}"
    done
    docker build --tag "htcondor/${NAME}:latest" "notebooks/${NAME}" > "${NAME}.out" 2>&1
    tail -n 1 "${NAME}.out"
    VERSION=$(grep \$CondorVersion: "${NAME}.out")
    VERSION=${VERSION#* }
    VERSION=${VERSION%% *}
    docker tag "htcondor/${NAME}:latest" "htcondor/${NAME}:${VERSION}"
    docker push "htcondor/${NAME}:${VERSION}"
    docker push "htcondor/${NAME}:latest"
done
