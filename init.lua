#! /usr/bin/env lua
--
-- english.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

-- windows  path setup 

USERDIR= ( USERDIR or  os.getenv("APPDATA") or "" ) .. [[\Rime]]

local Cmd_enable="VD"
local Cmd_enable_status="cmd_enable"

local Hotkey_Next="Control+0"
local Hotkey_Prev="Control+9"

local Hotkey_Complete="Control+8"
local Completion="completion"  -- get_option()

local Hotkey_Quickcode="Control+7" -- get_option() 
local Quickcode_switch="qcode_switch"

local Hotkey_Off= "Control+6"   -- get_option() 
local Reverse_switch= "reverse_switch"

local Lua_Command="lua_cmd"

local CandInfo_switch = "candinfo_switch"
local Hotkey_CandInfo="Control+F11"

--local init_data= require("muti_reverse/load_schema")  -- return function 
--local  schema_data  -- reference to  env.schema
-- init  dictionary  function to string table 
local function toggle_mode(env,name)
	local context=env.engine.context
	local name_status=context:get_option(name)
	context:set_option(name , not name_status)
end 

--if context:is_composing() and  [,/. ] then
local function  commit_chk(char,env) 
	local context=env.engine.context

	if not context:is_composing()  then return false end  
	if char:match([[^[, ]$]]  ) then  return true
	elseif  char == "."  and not context:has_menu() then return true
	else return false end  
end 
function commit_input(env)
	local context=env.engine.context
	local cand= context:get_selected_candidate()
	context.input = (cand and cand.text ) or context.input  -- 更新 context.input
	context:commit() 
end 

local function hotkey_cmd(env,hotkey)
	local context= env.engine.context

	--if hotkey == Hotkey_Reset      then  index=1  return true  end 
	if hotkey == Hotkey_Off   then  context:set_property("switch","toggle")  return true  end 
	--  下一個反查
	if  hotkey == Hotkey_Next then context:set_property("switch","next") return true end 
	--  上一個反查
	if  hotkey == Hotkey_Prev then context:set_property("switch","prev") return true end 	
	-- complation on off
	if hotkey == Hotkey_Complete  then  toggle_mode(env,Completion)  return true end 
	--if hotkey == Hotkey_Complete and not  context:is_composing()  then  toggle_mode(env,Completion)  return true end 
	-- quick code on off 
	if hotkey == Hotkey_Quickcode  then  toggle_mode(env,Quickcode_switch)  return true end 
	-- filter candinfo on off 
	if hotkey == Hotkey_CandInfo   then  toggle_mode(env,CandInfo_switch) return true end 

	return false 
end 
local function status(ctx)
	local stat=metatable()
	local comp= ctx.composition
	stat.always=true
	stat.composing= ctx:is_composing()
	stat.has_menu= ctx:has_menu()
	stat.paging= not comp:empty() and comp:back():has_tag("paging") 
	return stat
end 


local function lua_init(pattern_name)
	local  index

	local function processor_func(key,env) -- key:KeyEvent,env_
		local Rejected, Accepted, Noop = 0,1,2 
		local context=env.engine.context 
		local status= status(context) 
		local composition=context.composition
		local cmd_enable_status= context:get_option(Cmd_enable_status) 
		local keycode=key.keycode 
		local keyrepr=key:repr()
		if ( key:alt() or key:release() ) then return Noop end 

		if status.always then 
			if hotkey_cmd(env,key:repr()) then return Accepted end 

		elseif status.compsing then

		elseif status.has_menu then 

		elseif status.paging then 

		else 

		end 
		return Noop  
	end  

	local function processor_init_func(env)
		local context= env.engine.context 
		--[[
		env.connection_commit=context.commit_notifier:connect(
		function(context)
		end )
		env.connection_property=context.property_update_notifier:connect(
		function(context,name)
		end )
		env.connection_option=context.option_update_notifier:connect(
		function(context,name)
		end )
		--]]
	end 
	local function processor_fini_func(env)
		--[[
		if env.connection_commit then  env.connection_commit:disconnect() end 
		if env.connection_propert then env.connection_property:disconnect() end 
		if env.connection_option then  env.connection_option:disconnect() end 
		--]]
	end 


	-- lua segmentor
	local function segmentor_func(segs ,env) -- segmetation:Segmentation,env_
	--[[
	local context=env.engine.context
	local cartpos= segs:get_current_start_position()
	local cmd_enable_status= context:get_option(Cmd_enable_status)

	-- 在english_mode() 為 input 打上 english tag  
	if cmd_enable_status  and context:is_composing() then 
	local str = segs.input:sub(cartpos) 
	if not  str:match("^%a[%a'?*_.-]*") then  return true  end 
	local str= segs.input:sub(segs:get_current_start_position() )
	local seg=Segment(cartpos,segs.input:len())
	seg.tags=  Set({Lua_Command})
	seg.prompt="-------"
	segs:add_segment(seg) 

	-- 終止 後面 segmentor   打tag
	return false 
	end 
	-- 不是 english_mode  pass 此 segmentor  由後面處理 
	return true
	--]]
	end 
	local function segmentor_init_func(env)
		--[[
		env.connection_commit=context.commit_notifier:connect(
		function(context)
		end )
		env.connection_property=context.property_update_notifier:connect(
		function(context,name)
		end )
		env.connection_option=context.option_update_notifier:connect(
		function(context,name)
		end )
		--]]
	end 
	local function segmentor_fini_func(env)
		--[[
		if env.connection_commit then  env.connection_commit:disconnect() end 
		if env.connection_propert then env.connection_property:disconnect() end 
		if env.connection_option then  env.connection_option:disconnect() end 
		--]]
	end 
	-- lua translator 
	local function translator_func(input,seg,env)  -- input:string, seg:Segment, env_
	--[[
	local context= env.engine.context
	local cmd_enable_status=context:get_option(Cmd_enable_status) 
	log.info("-----translator: start" .. type(input) .. ":" .. tostring(input) ) 
	--if seg:has_tag(Lua_Command) then 
	if  input:macth("^V") then 
	for i,v in ipairs(schema_data) do 
	local cand=Candidate(Lua_Command, seg.start,seg._end, input .. v["text"], "反查-" .. v["tips"])
	yield(cand)
	end
	yield(Candidate( Lua_Command, seg.start,seg._end, input .. "n" , "反查-Next(" .. Hotkey_Next .. ")") )
	yield(Candidate( Lua_Command, seg.start,seg._end, input .. "p" , "反查-Prev(" .. Hotkey_Prev .. ")") )
	yield(Candidate( Lua_Command, seg.start,seg._end, input .. "q" , "簡碼開關 (" .. Hotkey_Quickcode .. ")") )
	yield(Candidate( Lua_Command, seg.start,seg._end, input .. "d" , "除錯開關 ("  ..  ")") )
	yield(Candidate( Lua_Command, seg.start,seg._end, input .. "z" , "全碼開關 (" .. Hotkey_Complete .. ")") )
	end 
	--end 

	--]]
	end 

	local function translator_init_func(env)
		--[[
		env.connection_commit=context.commit_notifier:connect(
		function(context)
		end )
		env.connection_property=context.property_update_notifier:connect(
		function(context,name)
		end )
		env.connection_option=context.option_update_notifier:connect(
		function(context,name)
		end )
		--]]
	end 
	local function translator_fini_func(env)
		--[[
		if env.connection_commit then  env.connection_commit:disconnect() end 
		if env.connection_propert then env.connection_property:disconnect() end 
		if env.connection_option then  env.connection_option:disconnect() end 
		--]]
	end 

	-- lua filter

	local function filter_func(input,env)  -- input:Tranlation , env_
		local context = env.engine.context
		local completion = context:get_option(Completion) 

		for cand in  input:iter() do  -- filter cand.type "completion" 
			if completion and cand.type == "completion" then break end 
			cand.comment= cand.comment .. "| " .. env.filter:filter(cand.text) .. env.candinfo:filter(cand) 
			yield(cand) 
		end 
	end 

	local function filter_init_func(env) -- non return 
		local context=env.engine.context 
		-- load schema_data
		local  schema_data = require("muti_reverse/load_schema")(env)  -- return function 
		-- init   env.filter,env.qcode, env.candinfo ,env.main_tran 
	    env.filter,env.qcode, env.candinfo,env.main_tran= require('muti_reverse/filter_init')(
		      schema_data["trans_env"], pattern_name)  


		-- register  notifier 
		env.connection_commit=context.commit_notifier:connect(
		function(context)
			if context:get_option( Cmd_enable_status) then 
				toggle_mode(env, Cmd_enable_status)
				execute(context)
			end 
		end )
		env.connection_property=context.property_update_notifier:connect(
		function(context,name)
			if name == "switch" then  --  chang filter_switch function 
				local value=context:get_property(name)
				env.filter:str_cmd( ("%s:%s"):format(name,value) ) 
				context:refresh_non_confirmed_composition()
			end 

		end )
		env.connection_option=context.option_update_notifier:connect(
		function(context,name)
			local value = context:get_option(name) -- option chang  and refresh 
			if name == Completion  then  
			end  
			if name ==  Quickcode_switch then 
				env.qcode:set_status(value) 
			end 
			if name == CandInfo_switch then 
				env.candinfo:set_status(value)
			end 
		end )
	end 
	local function filter_fini_func(env)  -- non return 
		-- [[
		if env.connection_commit then  env.connection_commit:disconnect() end 
		if env.connection_propert then env.connection_property:disconnect() end 
		if env.connection_option then  env.connection_option:disconnect() end 
		schema_data=nil 
		env.filter:reset()
		env.filter=nil	
		env.qcode=nil
		env.completion=nil 
		-- clear  env 
		--]]
	end 

	return { 
		processor= { func=processor_func, init=processor_init_func, fini=processor_fini_func} , 
		--segmentor= { func= segmentor_func, init=segmentor_init_func , fini=segmentor_fini_func} , 
		--translator={ func=translator_func, init=translator_init_func,fini=translator_fini_func} , 
		filter=    { func=filter_func, init=filter_init_func,    fini=filter_fini_func } ,   
		--filter1=    { func=filter_func1, init=filter_init_func1,    fini=filter_fini_func1 } ,   
	}

end 
-- init  lua component  to global variable


return lua_init



