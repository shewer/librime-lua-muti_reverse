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
local function make( )
	--local revfilter  =require("test")
	local revfilter=require("reverse_init")


	local function processor(key,env)   -- 攔截 trig_key  循環切換反查表  index_num  +1 % base   
		local kAccepted = 1
		local kNoop=2
		local engine = env.engine
		local context = engine.context
		if revfilter.switch:check_hotkey(key:repr()) then
			context:refresh_non_confirmed_composition() -- 刷新 filter data 
			return kAccepted
		elseif revfilter.switch:check_text( context.input ) then  
			context:clear()  -- 清除 contex data 
			return kNoop
		end 
		return kNoop
	end 


	local function filter(input,env) 
		--local cand_count= CAND_MAX or -1  -- 可在 rime.lua 設定 全域變數 CAND_MAX 最大反查數量
		for cand in input:iter() do
			if  not revfilter.enable_completion( cand ) then  break end -- enable_completion: ture /false 
				--cand:get_genuine().comment = cand.preedit .. "|" .. cand.comment .. "|"  ..  cand.text:filter()
				--cand:get_genuine().comment = cand.comment .. " " ..  FILTER:filter(cand.text)  -- :filter()
				cand:get_genuine().comment = cand.comment.." "..cand.text:filter() .. revfilter.debug(cand)   -- :filter()
				yield(cand) 
			--cand_count = cand_count -1 -- 超出反查數量  放棄反查 
			--if  0 == cand_count  then  break end 
		end
	end 

	local function init(env)  
		 
		 revfilter.open() -- open ReverseDbs 
		 log.info(string.format("---------------%s------------%s----" , revfilter.filter_switch,FILTER) )
	end 
	return { reverse = { init = init, func = filter } , processor = processor }  -- make() return value
end  


return make 
