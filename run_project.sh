#!/bin/sh

prgName=$1


if [ -z "$3" ]; then
    echo "using default os"
    os="centos/7"
else
    os=$3
fi


optional_dts=''
if echo $os | grep -q "/dts/4"; then
    optional_dts='devtoolset-4'
elif echo $os | grep -q "/dts/2"; then
    optional_dts='devtoolset-2'
elif echo $os | grep -q "/dts/"; then
    echo "!Unknown dts set up: "$os
    exit 1;
fi



genRunScript()
{
    UID=`stat -c "%u" ~`
    GID=`stat -c "%g" ~`

    mkdir -p $scriptPath

    cat > $scriptPath/$scriptName <<-EOF
		#!/bin/sh

		rm -rf /prg/build/devel/*

		chown -R $UID:$GID /root /prg /work /script /tools /tmp
		echo ":x:$UID:$GID::/root:/bin/bash" >> /etc/passwd
		sudo -u \#$UID scl enable $optional_dts onixs-devtoolset "/work/bin/clion.sh /prg/CMakeLists.txt"
		EOF

    chmod +x $scriptPath/$scriptName
}



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

scriptPath="/tmp/Scripts/"$prgName"/"$envName
scriptName=run_on_docker.sh

echo "scriptPath:" $scriptPath

[ -f $scriptPath/$scriptName ] || genRunScript


echo "os:" $os
echo "dts detected:" $optional_dts
echo "projet path:" $prgPath
echo "projet output:" $outputPath
echo ""

xhost +local:

version=CLion2018.3

docker run --rm -it --privileged                                                                    \
-e DISPLAY=unix$DISPLAY                                                                             \
--security-opt seccomp=unconfined                                                                   \
-v /tmp/.X11-unix:/tmp/.X11-unix                                                                    \
-v $clionPath/$version:/work                                                                        \
-v $clionPath/SharedConfig/$version:/root/.$version                                                 \
-v $clionPath/SharedConfig/userPrefs:/root/.java/.userPrefs/jetbrains                               \
-v $scriptPath:/script                                                                              \
                                                                                                    \
-v $clionPath/SharedConfig/$version/consentOptions:/root/.$version/system/consentOptions            \
-v /tmp/$prgName:/root/.$version/system/                                                            \
-v $prgPath/.cash/caches:/root/.$version/system/caches                                              \
-v $prgPath/.cash/index/.persistent:/root/.$version/system/index/.persistent                        \
                                                                                                    \
-v $prgPath:/prg                                                                                    \
                                                                                                    \
-v $toolsPath:/tools                                                                                \
                                                                                                    \
-v $outputPath:/prg/build/devel                                                                     \
onixs-docker-images.jfrog.io/$os/devel/ui/$envName                                                  \
/script/$scriptName
