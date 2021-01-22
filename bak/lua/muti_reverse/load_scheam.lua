#! /usr/bin/env lua
--
-- load_scheam.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
local Schema= require('tools/schema_func') 



local function get_translator_segmentions(config) 
	local tab=metatable()
	local key="engine/translators"
	local tab= Schema.get_list(config,key,"string"):select( 
	function(elm)  
		local segment=elm:match("table_tra.*@(.*)") or elm:match("script_tar.*@(.*)") 
		return segment 
	end):map( 
	function(elm) 
		return elm:match("table_tra.*@(.*)") or elm:match("script_tar.*@(.*)") 
	end )
	tab:insert(1,"translator") -- main dictionary  insert to first
	return tab 

end 


local function init_data(env)
	local config=env.engine.schema.config
	local tab= get_translator_segmentions(config) 

	local key1= "dictionary"
	local key2= "preedit_format"
	local key3= "comment_format"
	local key4= "textkey"
	local key5= "hotkey"
	local tran_tab=tab:map( function(elm) 
		return  {
			dbname = Schema.getdata( config , elm .. key1 ), -- default "string"	
			prttern= Schema.get_list(config, elm .. key2 ), -- default "string"
			prttern= Schema.get_list(config, elm .. key3 ), -- default "string"
			text= Schema.get_data(config,elm .. key4),
			hotkey=Schema.get_data(config,elm.. key5),
		}
	end) 
	return tran_tab
end 



return init_data 
