#!/bin/sh

os=ubuntu/16.04

docker pull onixs-docker-images.jfrog.io/$os/devel

cat << EOF > Dockerfile
FROM onixs-docker-images.jfrog.io/$os/devel 
RUN apt-get update
RUN apt-get install -y libxtst6 libnotify-bin
EOF

docker build -t onixs-docker-images.jfrog.io/$os/devel/ui ./

rm Dockerfile
