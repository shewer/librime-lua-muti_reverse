#! /usr/bin/env lua
--
-- load_scheam.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
local inspect=require 'inspect'
require 'tools/metatable'
local schema_func=require('tools/schema_func')





local function init_data(env)
	local get_list=schema_func.get_list
	local get_data=schema_func.get_data

	local tab=metatable()
	local config=env.engine.schema.config
	-- load translator   table  and script 
	local key="engine/translators"
	local tab= get_list(config,key,"string"):select( function(elm)  
			local segment=elm:match("table_tra.*@(.*)") or elm:match("script_tra.*@(.*)") 
			--log.info( string.format( "- %s---select--%s ---    %s--",segment , key ,elm ) )
			return segment
		end):map( function(elm) 
			--log.info( string.format( "----map--%s ---    %s--" , key ,elm ) )
			return elm:match("table_tra.*@(.*)") or elm:match("script_tra.*@(.*)") 
		end )

	tab:insert(1,"translator") -- main dictionarypy  insert to first
    --   init-- 
	local keys=metatable( { 
		dbname= {"dictionary", "string"},
		preedit_fmt= {"preedit_format","list","string"},
		comment_fmt={"comment_format", "list","string"},
		text= {"textkey","string"},
		hotkey= {"hotkey","string"},
		tips={ "tips","string"},
	})


	local tran_tab=tab:map(function(elm)  -- elm : segment 
		    local  ttab=  metatable()
			ttab["seg"]=elm
			keys:each(function(v,k)  --  insert ttab[k] = getdata() 
				--    keys    V[1]  path   V[2] type    V[3]  list_type
				ttab[k]=  get_data(config,  elm .. "/" .. v[1] ,v[2], v[3] )   --config,key,  elm segment .. / subseg ,
			end )
			return ttab

		end )

	--log.info( inspect(tran_tab) )
	return tran_tab
end 

return init_data 
