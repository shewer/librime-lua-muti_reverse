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
log = log or require 'muti_reverse.log'
lualog = require 'muti_reverse.log'
local function make( )
	--local revfilter  =require("test")
	local revfilter=require("reverse_init")
	local filter,switch = revfilter.filter_switch ,revfilter.switch

	local function processor(key,env)   -- 攔截 trig_key  循環切換反查表  index_num  +1 % base   
		local kAccepted , kNoop=   1, 2
		local engine = env.engine
		local context = engine.context
		ENV=env 

		if switch:check_hotkey(key:repr(),env) then
			context:refresh_non_confirmed_composition() -- 刷新 filter data 
			return kAccepted
		elseif switch:check_text( context.input,env ) then  
			context:clear()  -- 清除 contex data 
			return kNoop
		end 
		return kNoop
	end 


	local function filter(input,env) 
		revfilter.filter_env=env
		for cand in input:iter() do
			--if  not revfilter.enable_completion( cand ) then  break end -- enable_completion: ture /false 
			cand:get_genuine().comment = cand.comment.." "..cand.text:filter() .. revfilter.debug(cand)   -- :filter()
			yield(cand) 
		end
	end 

    function objlist(obj,seg, ... )	
		local  _type= type(obj) 
		if _type == "string" then 
					yield(Candidate("debug",seg.start,seg._end, string.format("%s ",obj) ,"string"))
		elseif _type == "number" then 
					yield(Candidate("debug",seg.start,seg._end, string.format("%s ",obj) ,"number"))
		elseif _type == "function" then 
					yield(Candidate("debug",seg.start,seg._end, string.format("%s ",obj) ,"number"))
			--local ptab={ pcall(obj, ... ) }
			--for i,v in ipairs(ptab) do 
				--yield(Candidate("debug",seg.start,seg._end, string.format("%s : %s",i,v) ,"table"))
			--end
		elseif _type == "table"  then 
				for k,v in pairs(obj) do 
					yield(Candidate("debug",seg.start,seg._end, string.format("%s : %s",k,v) ,"table"))
				end 
		end 
	end 
	local function debug(_input,seg,env) 
		local localdata={env=env,seg=seg,reverse=revfilter}
		yield(Candidate("debug", seg.start, seg._end,_input , "dubug:"))
		local t , input = _input:match("^([GLF])(.*)$" )
		if not input then return end 
		local _tabb = input:split("|")
		local obj_str, argv_str = table.unpack( input:split("|") )

		local inp_tab = ( argv_str and argv_str:split(",") ) or {} 
		if  obj_str then 
			yield(Candidate("debug", seg.start, seg._end,string.format("-%s---%s-",obj_str,argv_str) , "dubug:"))

			local V=  (t =="L" and localdata) or _G	
			local obj
			obj=obj_str:split("."):reduce(function(elm,svg) 
				if svg[elm] then 
					return svg[elm] 
				else
					objlist(svg,seg, table.unpack(inp_tab ) )
				end
			end ,
			V)


		end 
	end 

	local function init(env)  
		 revfilter.open() -- open ReverseDbs 
		 log.info(string.format("---------------%s------------%s----" , revfilter.filter_switch,FILTER) )
	end 
	return { reverse = { init = init, func = filter } , processor = processor,debug=debug }  -- make() return value
end  


return make 
