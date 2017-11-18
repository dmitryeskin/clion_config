#!/bin/sh

os=centos/7

docker pull onixs-docker-images.jfrog.io/$os/devel

cat << EOF > Dockerfile
FROM onixs-docker-images.jfrog.io/$os/devel 
RUN yum update
RUN yum install -y libXtst.x86_64
ADD ./fonts/UbuntuMono-BI.ttf /usr/share/fonts/UbuntuMono-BI.ttf
ADD ./fonts/UbuntuMono-B.ttf /usr/share/fonts/UbuntuMono-B.ttf
ADD ./fonts/UbuntuMono-RI.ttf /usr/share/fonts/UbuntuMono-RI.ttf
ADD ./fonts/UbuntuMono-R.ttf /usr/share/fonts/UbuntuMono-R.ttf
RUN fc-cache -f -v
EOF

docker build -t onixs-docker-images.jfrog.io/$os/devel/ui ./

rm Dockerfile
