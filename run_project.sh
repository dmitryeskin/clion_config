#!/bin/sh


prgName=$1
#prgName=eurotlx
os=centos/7


prgPath=/home/dmitry/Data/work/$prgName

#outputDir=/home/dmitry/Data/work/output
#ramdrv
outputDir=/tmp/DevOutput

outputPath=$outputDir/$prgName


clionPath=/home/dmitry/Data/work/Clion


[ -f $outputPath ] && mkdir $outputPath


echo "os:" $os
echo "projet path:" $prgPath
echo "projet output:" $outputPath
echo ""


xhost +local:


uid=`stat -c "%u" ~`
gid=`stat -c "%g" ~`

docker run --rm -it                                                                                 \
-e DISPLAY=unix$DISPLAY                                                                             \
-e UID=$uid                                                                                         \
-e GID=$gid                                                                                         \
--security-opt seccomp=unconfined                                                                   \
-v /tmp/.X11-unix:/tmp/.X11-unix                                                                    \
-v $clionPath/clion-2017.2.3:/work                                                                  \
-v $clionPath/SharedConfig/CLion2017.2:/root/.CLion2017.2                                           \
-v $clionPath/SharedConfig/userPrefs:/root/.java/.userPrefs/jetbrains                               \
-v $clionPath:/script                                                                               \
                                                                                                    \
-v $prgPath:/prg                                                                                    \
-v $outputPath:/prg/build/devel                                                                     \
onixs-docker-images.jfrog.io/$os/devel/ui/$prgName                                                  \
/script/run_on_docker.sh




#/work/bin/clion.sh /prg/CMakeLists.txt

