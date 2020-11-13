#! /usr/bin/env lua
--
-- load_scheam.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
local inspect=require 'inspect'
require 'tools/metatable'
local schema_func=require('tools/schema_func') -- suport  get_data(key,type1,type2)   set_data(key,type1,type2 ,value)
-- update lua_env 



local translator_keys=metatable( { 
	reverse_disable={"reverse_disable","bool"} ,
	dbname= {"dictionary", "string"},
	preedit_fmt= {"preedit_format","list","string"},
	comment_fmt={"comment_format", "list","string"},
	text= {"textkey","string"},
	hotkey= {"hotkey","string"},
	tips={ "tips","string"},
})



local function load_user_data(env) 
	local get_list=schema_func.get_list
	local get_data=schema_func.get_data
		local tab=metatable()
		local config=env.engine.schema.config
		-- load translator   table  and script 
		local key="engine/translators"
		local translators_tab= get_list(config,key,"string"):select( function(elm)  
			local segment=elm:match("table_tra.*@(.*)") or elm:match("script_tra.*@(.*)") 
			--log.info( string.format( "- %s---select--%s ---    %s--",segment , key ,elm ) )
			return segment
		end):map( function(elm) 
		--log.info( string.format( "----map--%s ---    %s--" , key ,elm ) )
		return elm:match("table_tra.*@(.*)") or elm:match("script_tra.*@(.*)") 
	end )

	translators_tab:insert(1,"translator") -- main dictionarypy  insert to first
	--   init-- 

	local tran_tab=translators_tab:map(function(elm)  -- elm : segment 
		local  ttab=  metatable()
		ttab["seg"]=elm
		translator_keys:each(function(v,k)  --  insert ttab[k] = getdata() 
			--    keys    V[1]  path   V[2] type    V[3]  list_type
			ttab[k]=  get_data(config,  elm .. "/" .. v[1] ,v[2], v[3] )   --config,key,  elm segment .. / subseg ,
		end )
		return ttab

	end )
	log.info( inspect(tran_tab) )
	return tran_tab 
end 

local function update_lua_env(env,env_tab)
	local lua_env="lua_env"
	local config=env.schema.config
	for k,v in pairs(env_tab) do 
		local key= lua_env .. "/" .. k
		env_tab[k] = schema_func.getdata(config,key,type(v) )  or v
	end 
	return env_tab

end 

local function init_data( env , lua_env) 

	--return { user_data= load_user_data(env) , lua_env= update_lua_env(env,lua_env) }
	return load_user_data(env) 

end 

return init_data  
