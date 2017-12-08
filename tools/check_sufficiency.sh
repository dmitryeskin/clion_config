#!/bin/sh

checkedDir=/prg/include/
cd $checkedDir

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

for f in $(find * -name '*.h'); 
do 
echo -e $GREEN $f $NC

echo "#include <$f>" |                                                                              \
g++ -x c++ -std=c++03 -fsyntax-only -I$checkedDir -I/prg/build/devel/debug/include - 2>&1 |         \
grep -ve '<stdin>' |                                                                                \
sed -e 's/\(.*error.*\)/\o033[31m\1\o033[0m/'

done


