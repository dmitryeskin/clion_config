#!/bin/sh

checkedDir=/prg/include/
cd $checkedDir

for f in $(find * -name '*.h'); 
do 
echo $f
echo "#include <$f>" | g++ -x c++ -std=c++03 -fsyntax-only -I$checkedDir -I/prg/build/devel/debug/include - 2>&1 | grep -ve '<stdin>'
done


