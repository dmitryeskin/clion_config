#!/bin/sh


checkedDir=/prg/include/

oldpath=`pwd`
cd $checkedDir


for f in $(find * -name '*.h'); 
do 
echo $f
cat << EOF > test.cpp
#include <$f>
int main(){return 0;}
EOF
g++ test.cpp -o test.o -I$checkedDir -I/prg/build/devel/debug/include
rm -rf test.*

done


cd $oldpath
