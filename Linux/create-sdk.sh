#!/bin/bash
# export DOCKER_BUILDKIT=1
docker rmi ossia/score-sdk-base
docker build --squash --compress --force-rm -t ossia/score-sdk-base -f Dockerfile.centos .

mkdir -p /tmp/image
mkdir -p /tmp/image/ossia-sdk
cp -rf * /tmp/image/

docker run --rm -it \
           -v "/tmp/image:/image" \
           -v "/opt/ossia-sdk:/opt/ossia-sdk" \
           -w="/image" \
           ossia/score-sdk-base \
           /bin/bash /image/build-all.sh

tar caf score-sdk-linux-llvm.tar.xz /opt/ossia-sdk
