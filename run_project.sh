#!/bin/sh


genRunScript()
{
    UID=`stat -c "%u" ~`
    GID=`stat -c "%g" ~`

    mkdir $scriptPath

    cat > $scriptPath/$scriptName <<-EOF
		#!/bin/sh

		rm -rf /prg/build/devel/*

		chown -R $UID:$GID /root /prg /work /script /tools
		echo ":x:$UID:$GID::/root:/bin/bash" >> /etc/passwd
		sudo -u \#$UID scl enable onixs-devtoolset "/work/bin/clion.sh /prg/CMakeLists.txt"
		EOF

    chmod +x $scriptPath/$scriptName
}


prgName=$1
os=centos/7

if [ -z "$2" ]; then
    echo "using default env"
    envName=$prgName
else
    echo "using env: "$2
    envName=$2
fi



prgPath=~/Data/work/$prgName
toolsPath=~/Data/work/clion_config/tools


#ramdrv
outputDir=/tmp/DevOutput

outputPath=$outputDir/$prgName
clionPath=~/Data/work/Clion

scriptPath=/tmp/Script
scriptName=run_on_docker.sh

[ -f $scriptPath/$scriptName ] || genRunScript


echo "os:" $os
echo "projet path:" $prgPath
echo "projet output:" $outputPath
echo ""

xhost +local:



docker run --rm -it                                                                                 \
-e DISPLAY=unix$DISPLAY                                                                             \
--security-opt seccomp=unconfined                                                                   \
-v /tmp/.X11-unix:/tmp/.X11-unix                                                                    \
-v $clionPath/clion-2017.3:/work                                                                    \
-v $clionPath/SharedConfig/CLion2017.3:/root/.CLion2017.3                                           \
-v $clionPath/SharedConfig/userPrefs:/root/.java/.userPrefs/jetbrains                               \
-v $scriptPath:/script                                                                              \
                                                                                                    \
-v /tmp/$prgName:/root/.CLion2017.3/system/                                                         \
-v $prgPath/.cash/caches:/root/.CLion2017.3/system/caches                                           \
-v $prgPath/.cash/index/.persistent:/root/.CLion2017.3/system/index/.persistent                     \
                                                                                                    \
-v $prgPath:/prg                                                                                    \
                                                                                                    \
-v $toolsPath:/tools                                                                                \
                                                                                                    \
-v $outputPath:/prg/build/devel                                                                     \
onixs-docker-images.jfrog.io/$os/devel/ui/$envName                                                  \
/script/$scriptName
