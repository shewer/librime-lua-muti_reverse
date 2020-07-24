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

function comment_list(pattern) 
	for k,v in pairs(comment_tab) do
		print( "key: "..k ,"dbname: " .. v.dbname )
		if pattern then 
			print("------- pattern ----------")
			for i,pat in ipairs(v.pattern ) do
				print(i,pat)
			end 
		end 
	end 
end 

local function get_comment(str,quick_key)
    local rever_dict_tab={}
    if comment_tab[str] then
        rever_dict_tab.dbname=comment_tab[str].dbname
        rever_dict_tab.text=quick_key
        rever_dict_tab.reverse_func= require("format")(   table.unpack(comment_tab[str].pattern ) )
    else
        for k,v in pairs( comment_tab) do
            if v.dbname:match( str)  then
                rever_dict_tab.dbname=v.dbname
                rever_dict_tab.text=quick_key
                rever_dict_tab.reverse_func= require("format")(  table.unpack(v.pattern) )
                break
            end
        end

     end
     return rever_dict_tab
end
return get_comment


EOF
