#! /usr/bin/env lua
--
-- english.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

-- windows  path setup 

USERDIR= ( USERDIR or  os.getenv("APPDATA") or "" ) .. [[\Rime]]
--require "english/english_init"
--string.find_word,string.word_info= require("english/english_dict")() 

local Cmd_enable="VD"
local Cmd_enable_status="cmd_enable"
local Hotkey_Next="Control+0"
local Hotkey_Prev="Control+9"

local Hotkey_Complate="Control+8"
local Completion="completion"  -- get_option()

local Hotkey_Quickcode="Control+7" -- get_option() 
local Quickcode_switch="qcode_switch"

local Hotkey_Off= "Control+6"   -- get_option() 
local Reverse_switch= "reverse_switch"
local Lua_Command="lua_cmd"

require('english.english_init')
local init_data= require("muti_reverse/load_schema")  -- return function 
local  schema_data  -- reference to  env.schema
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

local function complate_text(env) 
	local context=env.engine.context
	local seg=context.composition:back()
	log.info( string.format( "--complate start has_menu:%s  menu_count: %s, select_index: %s", 
	context:has_menu(), seg.menu:candidate_count() ,seg.selected_index ) ) 
	if not seg then return  end 

	-- 在 intput 字串 有 "/"  補齊 wildfmt 如 auto/i  --> auto*ing  
	if  context.input:match("/") then -- and backup_input ~= word  then 
		local _ , word , part= dict.wildfmt(context.input)
		env.history_words:insert(context.input)

		part = ( part == ""  and  "" ) or  ":"  .. part
		log.info( string.format( "--complate   / :%s  menu_count: %s, select_index: %s", 
		context:has_menu(), seg.menu:candidate_count() ,seg.selected_index ) ) 
		context.input= word .. part
		return 
	end 

	-- 如果有 menu 以讀取 目前 select cand 補齊 input 
	if context:has_menu() then 
		local cand=seg:get_selected_candidate( )
		-- 如果 cand 是第一個 且 type== "pre_english" 重取下一個 cand 補齊  
		if  seg.selected_index == 0 and cand.type == Pre_english and seg.menu:candidate_count() >=1  then  
			cand= seg:get_candidate_at(seg.selected_index +1 ) 
		end 
		env.history_words:insert( context.input )
		log.info( string.format( "--complate has_menu  hasmenu :%s  menu_count: %s, select_index: %s", 
		context:has_menu(), seg.menu:candidate_count() ,seg.selected_index ) ) 
		context.input= cand.text
	end 
end 
local function restort_word(env) 
	local context=env.engine.context
	context.input=  env.history_words:remove()  or context.input 
end 
local function hot_keyword1(hotkey,env) 
	local context=env.engine.context
	local wildword_ = (env.keyname2[hotkey] and "*" ..  env.keyname2[hotkey] ) or "" 
	env.history_words:insert(context.input)
	context.input = context.input  .. wildword_ 
end 
local function hotkey_cmd(env,hotkey)
	local context= env.engine.context

	--if hotkey == Hotkey_Reset      then  index=1  return true  end 
	if hotkey == Hotkey_Off        then  context:set_property("switch","off")  return true  end 
	--  下一個反查
	if  hotkey == Hotkey_Next then context:set_property("switch","next") return true end 
	--  上一個反查
	if  hotkey == Hotkey_Prev then context:set_property("switch","prev") return true end 	
	if hotkey == Hotkey_Complate   then  toggle_mode(env,Completion)  return true end 
	if hotkey == Hotkey_Quickcode  then  toggle_mode(env,Quickcode_switch)  return true end 

	return false 
end 


local function lua_init()
	local  index

	local function processor_func(key,env) -- key:KeyEvent,env_
		local Rejected, Accepted, Noop = 0,1,2 
		local context=env.engine.context 
		local composition=context.composition
		local is_composing=context:is_composing()
		local cmd_enable_status= context:get_option(Cmd_enable_status) 

		-- 任何模式下
		--  toggle mode    ascii - chinese  -- english -- ascii 
		if hotkey_cmd(env,key:repr()) then 
			context:refresh_non_confirmed_composition() --
			return Accepted
		end 
		--if (key:ctrl() or key:alt() or key:release() ) then return k.Noop end 
		-- english mode  pass  alt release 
		if ( key:alt() or key:release() ) then return Noop end 
		
		local keycode=key.keycode 
		local keyrepr=key:repr()

		-- context.input 有資料時 , 需要處理的keyevent
		if is_composing then 
			-- 如果  enable  第二字 也以收下 且 檢查 是否執行命令
			--if env.cmd_enable_status then 
				--if  keychar:match([[^[%a%:/'?*_.-]$]]) then
					--context:push_input(keychar)
					--return Accepted
				--end 
			--else 
				--return Noop
			--end 
		else 
			--  在 not is_composing 時如果 第一字母 Cmd_enable 
			--if  Cmd_enable:match(keychar) then 
				--context:set_option( Cmd_enable_status, true)
				--context:push_input(keychar)
				--return Accepted
			--end  
		end 
		return Noop  
	end  

	local function processor_init_func(env)
		local context= env.engine.context 
		schema_data=init_data(env) 
		env.connection_commit=context.commit_notifier:connect(
		function(context)
			if context:get_option( Cmd_enable_status) then 
				toggle_mode(env, Cmd_enable_status)
				execute(context)
			end 
		end )
		env.connection_property=context.property_update_notifyer:connect(
		function(context,name)
		end )
		env.connection_option=context.option_update_notifier:connect(
		function(context,name)
		end )




	end 
	local function processor_fini_func(env)
		env.connection_commit:disconnect()
		env.connection_property:disconnect()
		env.connection_option:disconnect()
	end 


	-- lua segmentor
	local function segmentor_func(segs ,env) -- segmetation:Segmentation,env_
		local context=env.engine.context
		local cartpos= segs:get_current_start_position()
		local cmd_enable_status= context:get_option(Cmd_enable_status)

		-- 在english_mode() 為 input 打上 english tag  
		if cmd_enable_status  and context:is_composing() then 
			local str = segs.input:sub(cartpos) 
			if not  str:match([[^%a[%a'?*_.-]*]]) then  return true  end 
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
	end 

	local function segmentor_init_func(env)
	end 
	local function segmentor_fini_func(env)
	end 
	-- lua translator 
	local function translator_func(input,seg,env)  -- input:string, seg:Segment, env_
		local context= env.engine.context
		local cmd_enable_status=context:get_option(Cmd_enable_status) 
		if seg:has_tag(Lua_Command) then 
			if input:math("^V$") then 
				for i,v in ipairs(schema_data) do 
					local cand=Candidate(Lua_Command, seg.start,seg._end, input .. v["text"], "反查-" .. v["tips"])
					yield(cand)
				end
				yield(Candidate( Lua_Command, seg.start,seg._end, input .. "n" , "反查-Next(" .. Hotkey_Next .. ")") )
				yield(Candidate( Lua_Command, seg.start,seg._end, input .. "p" , "反查-Prev(" .. Hotkey_Prev .. ")") )
				yield(Candidate( Lua_Command, seg.start,seg._end, input .. "q" , "簡碼開關 (" .. Hotkey_Quickcode .. ")") )
				yield(Candidate( Lua_Command, seg.start,seg._end, input .. "d" , "除錯開關 ("  ..  ")") )
				yield(Candidate( Lua_Command, seg.start,seg._end, input .. "z" , "全碼開關 (" .. Hotkey_Complate .. ")") )
			end 
		end 
		
	end 

	local function translator_init_func(env)
	end 
	local function translator_fini_func(env)
	end 

	-- lua filter

	--  cand data to string 
	local function filter( env,text , filter_tab) 
		if not filter_tab then return nil,text end 
		if not env.engine.context:get_option(Reverse_switch) then return text,text end 
		local rever_text=  filter[1]:lookup(text)
		local text1,text2=text,text
		text1,text2 = filter_tab[2]( text1 ,env.engine.context:get_option( Quickcode_switch ) )
		for i,func in ipairs(filter_tab) do 
			text1,text2 = func(reverse_text1) 
		end 
		return text1,text 
	end 

		
		
			
	local function filter_func(input,env)  -- input:Tranlation , env_
		local context=env.engine.context
		local comp=env.completion:New(input, context:get_option(Completion)  )
		for cand in  comp:iter() do  -- filter cand.type "completion" 
			cand.comment= env.filter:filter(cand.text) 
			yield(cand) 

		end 
	end 

	local function filter_init_func(env) -- non return 
		-- return tabs { { reverdb, qcode_code, {func_list} } ,......... }  obj , func  ,funcs 
		env.filter,env.qcode,env.completion= require('muti_reverse/filter_init')(schema_data)  
		env.connection_commit=context.commit_notifier:connect(
		function(context)
			if context:get_option( Cmd_enable_status) then 
				toggle_mode(env, Cmd_enable_status)
				execute(context)
			end 
		end )
		env.connection_property=context.property_update_notifyer:connect(
		function(context,name)
			if name == "switch" then  --  chang filter_switch function 
				local value=context:get_property(name)
				env.filter:str_cmd( name .. ":" .. value) 
				context:refresh_non_confirmed_composition()
			end 

		end )
		env.connection_option=context.option_update_notifier:connect(
		function(context,name)
			local value = contex:get_option(name) -- option chang  and refresh 
			if name == Completion  then  context:refresh_non_confirmed_composition()  end  
			if name ==  Quickcode_switch then 
				env.qcode:set_status(value) 
				context:refresh_non_confirmed_composition()
			end 
		end )

		-- load schema    translator  tips  dictionary 
	end 
	local function filter_fini_func(env)  -- non return 
		schema_data=nil 
		for i,v in ipairs(env.filter) do 
			v[1]=nil -- reversedb obj
			v[2]=nil -- quick_code func
			v[3]=nil -- conver_patterns  func 
		end 
		env.qcode=nil
		env.completion=nil 
		env.connection_commit:disconnect()
		env.connection_property:disconnect()
		env.connection_option:disconnect()
		-- clear  env 
	end 

	return { 
		processor= { func=processor_func, init=processor_init_func, fini=processor_fini_func} , 
		--segmentor= { func= segmentor_func, init=segmentor_init_func , fini=segmentor_fini_func} , 
		--translator={ func=translator_func, init=translator_init_func,fini=translator_fini_func} , 
		filter=    { func=filter_func, init=filter_init_func,    fini=filter_fini_func } ,   
	}

end 
-- init  lua component  to global variable
local function init(tagname, unload_)
	local tab_= lua_init() 
	for k,v in pairs( tab_) do 
		local kk= tagname .. "_" .. k 
		_G[kk] =  ( not unload_ and  v ) or nil  --  load and v    or  nil 
	end 


end 


return init



