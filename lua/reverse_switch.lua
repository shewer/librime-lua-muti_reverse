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
lualog = log 
lualog= lualog or  log -- 
log=require( 'muti_reverse.log')(lualog)
local function make( )
	--local revfilter  =require("test")
	local revfilter=require("reverse_init")
	local rimelua_debug=require("rimelua_debug")
	FILTER= FILTER or revfilter.filter_switch

	local function processor(key,env)   -- 攔截 trig_key  循環切換反查表  index_num  +1 % base   
		local kAccepted , kNoop=   1, 2
		local engine = env.engine
		local context = engine.context
		local switch = revfilter.switch
		local localdata=revfilter  --  for debug
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



	local function translator(input,seg,env) -- debug translator
		local localdata=revfilter  --  for debug
		--local schema_tran= require('muti_reverse.load_schema')(env)
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


	local function chk_codemin(cand) -- revese code  seg._end - seg_start
		local filter= revfilter.mainfilter 
		filter:list()[3]:off()  --   { dbfilter, qcodefilter, psfilter}[3]:off()
		local len = ( filter:filter(cand.text):split()[1] or "" ):len() --- 空字串  split()[1] == nil 
		filter:list()[3]:on()  --   { dbfilter, qcodefilter, psfilter}[3]:on()
		return (cand._end - cand.start)  <=len  
	end 

	local function qcodetip(text)
		return "*簡:" ..  revfilter.mainfilter:filter(text) ..(")")
	end 
	local function candinfo_func(cand,option)
		if option then 
			return  string.format("t:%s s:%s e:%s q:%6.3f,%s",cand.type,cand.start,cand._end,cand.quality,cand.preedit)
		else 
			return ""
		end 
	end 

	-- ------------------------------------------------------------------
	local function filter(input,env) 
		local context=env.engine.context
		local candinfo= context:get_option("candinfo") 
		local completion = context:get_option("completion")
		local count=1
		local backup_cand=metatable() 

		for cand in input:iter() do

			if completion   and cand.type == "completion" then break end     -- 全碼下屏開關
			if  cand.type== "raw" then break  end  --  移除 type raw 

			cand.comment= cand.comment ..  cand.text:filter() .. candinfo_func(cand,candinfo) --  
			if cand.type == "debug" then  -- cand.type 
				yield(cand) 
			elseif cand.type ~= "completion" then --全碼字
				if  not chk_codemin(cand) then -- 最簡碼檢查
					cand.comment= qcodetip(cand.text) .. cand.comment  -- 增加 提示
			    end 
				if 2 < (cand._end - cand.start) then  -- code > 2  備份往後排  
					backup_cand:insert( cand)  
				else 
						yield(cand)  -- 一 二碼  提示 不後排
				end 
            else  -- 未全碼字 
				--  如果 有備份 要上屏後清除 
				backup_cand:each(function(elm) yield(elm) end )
				backup_cand=metatable()  --  clean 
				yield(cand) -- 其他字 上屏
			end 
			count=count+1
		end 
		-- 如果input 只有一個且 不是最簡碼 backup_cand 須要回補
		backup_cand:each(function(elm) yield(elm) end ) 
		backup_cand=metatable()  --  clean 

	end 



	local function init(env)  
		log.info( "*********  init reload ******************** ")	
		local schema= require('muti_reverse.load_schema')(env)   -- 反查字典 取自 主副字典  及 preedit_format 
		--schema=require('muti_reverse.schema_sim')   -- 自設  檔也可改檔名  資料格式 依此檔
		revfilter:open(schema) -- load schema find table and script traslator  and ReverseDbs 
		env=revfilter
	end 

	return { reverse = { init = init, func = filter } , processor = processor, translator = translator }  -- make() return value
end  


return make 
