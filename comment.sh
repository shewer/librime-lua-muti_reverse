#! /bin/sh
#
# comment.sh
# Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
#
# Distributed under terms of the MIT license.
#
TABNAME=$2

OUTFILE=./lua/$2.lua
DIR_PATH=$1/*.schema.yaml 
EXT_FILENAME=*.schema.yaml
echo $OUTFILE
cat <<EOF > $OUTFILE 
local $TABNAME= { }

EOF

for ff in $( ls $DIR_PATH ) 
do
	echo --  $ff 
	ruby comment.rb $ff $TABNAME 
done >> $OUTFILE 

cat <<EOF >> $OUTFILE



return $TABNAME 
EOF
