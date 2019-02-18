#!/bin/sh

#os=centos/7/dts/4
os=centos/7

docker pull onixs-docker-images.jfrog.io/$os/devel

cat << EOF > Dockerfile
FROM onixs-docker-images.jfrog.io/$os/devel 
RUN yum update -y
RUN yum install -y libXtst.x86_64 valgrind perf
RUN sudo sh -c 'echo 1 > /proc/sys/kernel/perf_event_paranoid'
RUN sudo sh -c 'echo 0 > /proc/sys/kernel/kptr_restrict'
ADD ./fonts/UbuntuMono-BI.ttf /usr/share/fonts/UbuntuMono-BI.ttf
ADD ./fonts/UbuntuMono-B.ttf /usr/share/fonts/UbuntuMono-B.ttf
ADD ./fonts/UbuntuMono-RI.ttf /usr/share/fonts/UbuntuMono-RI.ttf
ADD ./fonts/UbuntuMono-R.ttf /usr/share/fonts/UbuntuMono-R.ttf
RUN fc-cache -f -v
EOF

docker build -t onixs-docker-images.jfrog.io/$os/devel/ui .

rm Dockerfile
