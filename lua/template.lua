#! /usr/bin/env lua
--
-- main_init.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
--------------------------------------------


local function lua_init(...)
	local args={...} 

	local function processor_func(key,env) -- key:KeyEvent,env_
		local Rejected, Accepted, Noop = 0,1,2 

		return Noop  
	end 

	local function processor_init_func(env)
	end 

	local function processor_fini_func(env) 
	end 

	-- segmentor 
	local function segmentor_func(segs ,env) -- segmetation:Segmentation,env_


	-- 終止 後面 segmentor   打tag  
	-- return  true next segmentor check
		return true 
	end 
	local function segmentor_init_func(env)
	end 
	local function segmentor_fini_func(env)
	end 

	-- translator 
	local function translator_func(input,seg,env)  -- input:string, seg:Segment, env_

		-- yield( Candidate( type , seg.start,seg._end, data , comment )
	end 
	local function translator_init_func(env)
	end 
	local function translator_fini_func(env)
	end 

	--- filter  
	local function filter_func(input,seg,env)   -- pass filter 
		for cand in input:iter() do 
			yield(cand)
		end 
	end 
	local function filter_init_func(env)
	end 
	local function filter_fini_func(env)
	end 

	local _tab= { 
		processor= { func=processor_func, init=processor_init_func, fini=processor_fini_func} , 
		--segmentor= { func= segmentor_func, init=segmentor_init_func , fini=segmentor_fini_func} , 
		--translator={ func=translator_func, init=translator_init_func,fini=translator_fini_func} , 
		filter=    { func=filter_func, init=filter_init_func,    fini=filter_fini_func } ,   
		--filter1=    { func=filter_func1, init=filter_init_func1,    fini=filter_fini_func1 } ,   
	}
	return _tab
end 
-- create global  function  to   lua_component 
-- 



-- init  lua component  to global variable
-- create enter_processor in global
-- create enter_filter in global 
-- require( 'main_init')("enter",args) 
local function init(tagname,...)
	local _tab= lua_init(...) 
	local unload_keys={}
	for key,component_tab in pairs( _tab ) do 
		local component= tagname .. "_" .. key  --  
		_G[ component ] =   component_tab   --  load and v    or  nil 
		table.insert(unload_keys, component )
	end 
	return function()
		for i,unload_key in ipairs(unload_keys) do
			_G[ unload_key] = nil 
		end 
	end 
end 


return init    
