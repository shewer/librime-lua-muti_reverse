#! /usr/bin/env lua
--
-- load_scheam.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
require 'tools/metatable'
-- load schema function 
local schema_func=require('tools/schema_func') -- suport  get_data(key,type1,type2)   set_data(key,type1,type2 ,value)
-- update lua_env 

--  


local lua_env_keys=metatable( {

})

local translator_keys=metatable( { 
	reverse_disable={sub_path="reverse_disable",type="bool"} ,
	dbname= {sub_path="dictionary", type="string"},
	preedit_fmt= {sub_path="preedit_format",type="string",list=true},
	comment_fmt={sub_path="comment_format", type="string",list=true},
	text= {sub_path="textkey",type="string"},
	hotkey= {sub_path="hotkey",type="string"},
	tips={sub_path="tips",type="string"},
})

-- 取得 enging/translators/    list of  script_translator@segment_name table_translator@segment_name
local function get_translator_segmentions(config)

	local key="engine/translators"
	local tran_segment_name_tab= schema_func.get_list(config,key,"string"):select( 
	function(elm)  
		local segment=elm:match("table_tra.*@(.*)") or elm:match("script_tra.*@(.*)") 
		--log.info( string.format( "- %s---select--%s ---    %s--",segment , key ,elm ) )
		return segment
	end):map( 
	function(elm) 
		--log.info( string.format( "----map--%s ---    %s--" , key ,elm ) )
		return elm:match("table_tra.*@(.*)") or elm:match("script_tra.*@(.*)") 
	end )
	tran_segment_name_tab:insert(1,"translator") -- main dictionarypy  insert to first
	return tran_segment_name_tab -- return { "translator" , "pinyin" , "..."}
end

local function init_data( env ) 
	print("----- init_data(env) --:" , env ) 
	local config= env.engine.schema.config
	local lua_env_root= "lua_env"
	print( "in  init_data function call")
	
	--  從 engine/translators 取得 主 副 詞典 segname name -- { "translator" ,"pinyin" ,,,,,,,}  
	local tran_segments=get_translator_segmentions(config) 
	-- 取得  主 副 詞典 segment 的相關資料 (  translator_keys) 
	local trans_env= tran_segments:map(
	function(seg_name)
		-- return table 
		-- {path= seg_name ,value= obj , keyname={ value=... , name.... ....} .....}
	    return 	schema_func.load_user_data(config,seg_name,translator_keys) 
	end )
	--local i=require 'inspect'
	--print("--------schema data \n" ,  i.inspect(trans_env), "\n------ schema_data  end ------" )
	

	-- 取得 lua_ent 的相關資料 ( lua_env.keys ) 
	local lua_env_table=schema_func.load_user_data(config,lua_env_root,lua_env_keys) -- return table 


	-- 自行定義 return table
	return {trans_env=trans_env,lua_env= lua_env_table} 

end 

return init_data  
