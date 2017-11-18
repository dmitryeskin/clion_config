#!/bin/sh

rm -rf /prg/build/devel/*

#scl enable onixs-devtoolset "/work/bin/clion.sh /prg/CMakeLists.txt"


chown -R $UID:$GID /root /prg /work /script
echo ":x:"$UID:$GID"::/root:/bin/bash" >> /etc/passwd
sudo -u \#$UID scl enable onixs-devtoolset "/work/bin/clion.sh /prg/CMakeLists.txt"



#function finish {
#    echo "Exiting and setting output premissions."
#    chmod -R 0777 /prg/build/devel
#}

#trap finish EXIT
