#! /usr/bin/env lua
--
-- load_scheam.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
local function getdata(config,key,datatype)
	datatype = datatype or "string"
	if "int" == datatype or "number" == datatype then 
		return config:get_int(key)
	elseif  "dobule" == datatype then 
		return config:get_double(key)
	elseif "bool"  == datatype or  "boolean" == datatype then 
		return config:get_bool(key)
	elseif "string" == datatype then 
		return config:get_string(key)
	else 
	    return nil 
	end 
end 

local function get_list(config,key,datatype)
	datatype = datatype or "string"
	if not config:is_list(key) then return nil end 
	local tlocal ab=metatable()
	local list_size=config:get_list_size( key  )
	local tab=metatable()
	for i=0,(list_size -1) , 1 do
		tab:insert(  getdata( config, key .. "/@" .. i, datatype ) )
	end 
	return tab

end







local function init_data(env)

	local tab=metatable()
	local config=env.engine.schema.config
	local key="engine/translators"
	local tab= get_list(config,key,"string"):select( function(elm)  
			local segment=elm:match("table_tra.*@(.*)") or elm:match("script_tra.*@(.*)") 
			log.info( string.format( "- %s---select--%s ---    %s--",segment , key ,elm ) )
			return segment
		end)
 
		log.info( string.format( "-tablesize-%syy--map--%s ---    %s--", #tab , key ,elm ) )


		local tab=tab:map( function(elm) 
			log.info( string.format( "----map--%s ---    %s--" , key ,elm ) )
			return elm:match("table_tra.*@(.*)") or elm:match("script_tra.*@(.*)") 
		end )
	tab:insert(1,"translator") -- main dictionarypy  insert to first
		log.info( string.format( "-tablesize---map--%s ---    %s--", #tab , key ,elm ) )

	local key1= "dictionary"
	local key2= "preedit_format"
	local key3= "textkey"
	local key4= "hotkey"
	local tran_tab=tab:map(function(elm) 
		return  {
			dbname = getdata( config , elm .."/".. key1 ), -- default "string"	
			prttern= get_list(config, elm .."/".. key2 ), -- default "string"
			text= getdata(config,elm .."/".. key3),
			hotkey=getdata(config,elm.."/".. key4),
		}
	end) 
	return tran_tab
end 

return init_data 
