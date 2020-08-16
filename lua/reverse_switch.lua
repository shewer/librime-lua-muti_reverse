#! /usr/bin/env lua
--
-- reverse_switch.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
--  多反查字典 主程式

--
-- 簡碼開關
-- 簡碼飾選 


-- 反查碼 字根轉換函式   reverse_lookup_filter  init(env) 建立 {db: 反查檔 和 xform_func: 轉碼函式} 整合
-- 限定 filler 數量 : 後面的資料會衼 此filler 取消 
-- 已將反查 插入 string.filter 
--
-- string.filter(self,[ [func|table],...] )   return str table:filter(str) , return str func(str)
--[[
--ex:   function upcase(str)
--         return  string:upper()
--      end 
--      str="abcd"
--      str:filter(upcase)
--      filter1( filter2( filter3(str)))   --> str:filter(filter3):filter(filter2):filter(filter2) 
--
-- table 增加 each map reduce 需要 setmetatable __index=table
-- 
-- a=setmetatable({2,3,4,5,6},{__index=table}
-- a:each( function(elm) print(v,v*v) end )  
-- a:map(function(elm) return elm*elm end )  =>return  {4 ,9,25,36} 
--
-- 
--
--      
--
--
--
--
--
--
--
--
--]]
--lualog = log 
--log=require('muti_reverse.log')(log)

local function make( )
	--local revfilter  =require("test")
	local revfilter=require("reverse_init")
	local rimelua_debug=require("rimelua_debug")
	local filter,switch = revfilter.filter_switch ,revfilter.switch

	local function processor(key,env)   -- 攔截 trig_key  循環切換反查表  index_num  +1 % base   
		local kAccepted , kNoop=   1, 2
		local engine = env.engine
		local context = engine.context
		-- debug mode 
		local  cand=context:get_selected_candidate()
		local  candtype = cand  and cand.type
		local  candtext = cand  and cand.text


		-- 反查字典開關
		if switch:check_hotkey(key:repr(),env) then -- 熱鍵
			context:refresh_non_confirmed_composition() -- 刷新 filter data 
			return kAccepted
		elseif switch:check_text( context.input,env ) then --  
			context:clear()  -- 清除 contex data 
			return kNoop

		elseif  candtype == "debug" then -- debug mode    Tab  & Shift+Tab 

			if key:repr() == "Shift+Tab" then 
				local tempstr= context.input:match("^([LGF].+[%.])%w+[.]?") or context.input:match("^([LGF]).*") 
				context.input=tempstr
				return kAccepted

			end 
			if  key:repr() == "Tab" then --  tab key    補齊   input 字串   
				local tempstr= context.input:match("^([LGF].+[%.])%w*") or context.input:match("^([LGF]).*") 
				tempstr= tempstr .. candtext 
				if cand.comment:match("number") or cand.comment:match("function") or 
					cand.comment:match("string")  or cand.comment:match("boolean") then 
					context.input=tempstr
				else -- data type  table  userdata Object then  add "." in to  nest 
					tempstr= tempstr  .. "." 
					context.input=tempstr
				end 
				return kAccepted
			end 
			return kNoop
		end 
		return kNoop
	end 


	local function filter(input,env) 
		revfilter.filter_env=env
		for cand in input:iter() do
			if cand.type == "debug" then  
				cand:get_genuine().comment = cand.comment.." " .. revfilter.debug(cand)   -- :filter()
			else 
				cand:get_genuine().comment = cand.comment.." " ..  cand.text:filter()  ..  revfilter.debug(cand)   -- :filter()
			end 
			yield(cand) 
		end
	end 

	local function translator(input,seg,env) -- debug translator
		if input=="date" then 
			yield(   Candidate("date",seg.start,seg._end, os.date("%Y-%m-%d")  ,"日期" ) ) 
			yield(   Candidate("date",seg.start,seg._end, os.date("%Y年%m月%d日")  ,"日期" ) ) 
		elseif input=="time" then 
			yield(   Candidate("date",seg.start,seg._end, os.date("%H:%M:%S")  ,"時間" ) ) 
		elseif  input:match("^[GLF].*")  then 
			rimelua_debug(input,seg,env):each( function(elm) 
				yield( Candidate( "debug",seg.start,seg._end, string.format("%s",elm[1])  , type(elm[2]) ) )
			end )
		end 
	end 

	local function init(env)  
		revfilter.open() -- open ReverseDbs 
		env=revfilter
	end 
	return { reverse = { init = init, func = filter } , processor = processor, translator = translator }  -- make() return value
end  


return make 
