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
-- index_num 共用變數  供  processor , filter 用 

-- 簡碼飾選 


-- 反查碼 字根轉換函式   reverse_lookup_filter  init(env) 建立 {db: 反查檔 和 xform_func: 轉碼函式} 整合
-- 限定 filler 數量 : 後面的資料會衼 此filler 取消 

local function make( )
	local revdbs,switch =require("comment_init")


	local function processor(key,env)   -- 攔截 trig_key  循環切換反查表  index_num  +1 % base   
		local kAccepted = 1
		local kNoop=2
		local engine = env.engine
		local context = engine.context
		if switch:check(key:repr) then
			context:refresh_non_confirmed_composition() -- 刷新 filter data 
			return kAccepted
		elseif switch:check( context.input ) then  
			context:clear()  -- 清除 contex data 
			return kNoop
		else 
			return kNoop
		end 
		return kNoop
	end 

	local function filter(input,env) 
		local db= env.revdbs[index_num].db 
		local status , rever_code
		local cand_count= CAND_MAX or -1  -- 可在 rime.lua 設定 全域變數 CAND_MAX 最大反查數量
		for cand in input:iter() do
			cand:get_genuine().comment = cand.comment .. " " ..  env.dbs:conver(cand.text)
			yield(cand) 
			
			cand_count = cand_count -1
			if  0 == cand_count  then  -- 超出反查數量  放棄反查 
				break
			end 
		end
	end 
	-- revdbs ( array ) : { db= reverse_dbname , text= pattern }
	local function init(env)  -- 建立 revdb: Array { { db , revtable},{db,revtable} ..... }
		dbs:open() 
		env.revdbs= dbs 
	end 
	return { reverse = { init = init, func = filter } , processor = processor } 
end  

-- return  { db = ReverseDb(name) , revtable= xform_func } 

return make 
