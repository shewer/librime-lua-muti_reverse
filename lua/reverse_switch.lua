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
local quick_code_flag=false 
-- index_num 共用變數  供  processor , filter 用 
local index_num=0    --   init index_num=0   反查 off  

-- 簡碼飾選 
local function quick_code(codes_str,sep)
	-- init  sep char  and tab 
    local match_str ,tab= sep or "%S+" , {}
    if match_str == "" then
        match_str="."
    end
	-- conver to tab
    for v in string.gmatch(codes_str,match_str) do
        table.insert(tab,v)
    end
	-- bypass word less 2
	if #tab <2 then
		return codes_str
	end 
    -- sort tab    short word first 
	table.sort(tab,  function(a,b) return a:len() < b:len() end )
	-- combine string of  short words 
	local str,str_leng_min= "", tab[1]:len()
	for i,v in ipairs(tab) do
		if v:len() > str_leng_min then 
			break
		end 
		str= str..v.." "
	end 
	return str:match("%s*(.*[^%s])%s+")
end


-- 反查碼 字根轉換函式   reverse_lookup_filter  init(env) 建立 {db: 反查檔 和 xform_func: 轉碼函式} 整合
-- 限定 filler 數量 : 後面的資料會衼 此filler 取消 
local function reverse_lookup_filter1(input,db,func )
		if db then 
			cand:get_genuine().comment= cand.comment .. tostring(db) .. " " 
		end
		if func then 
			cand:get_genuine().comment= cand.comment .. tostring(func) .. " " .. db:lookup(cand.text)
		end 
	
end 
local function reverse_lookup_filter(input, db,func )
	local cand_count= CAND_MAX or -1  -- 可在 rime.lua 設定 全域變數 CAND_MAX 最大反查數量
	local rever_code  -- 反查碼
	local revered_code  -- 字根轉碼
	--log.info( "index: " .. tostring(index_num) .. "  db:"..tostring(db) .. "  reverfunc: " ..tostring(func)  )  
	for cand in input:iter() do
		if (db and func ) then -- 反查字典 和  轉換函式不為空 
			--  quick_code  on /off 
			if quick_code_flag then 
				rever_code = quick_code( db:lookup(cand.text) )
			else 
				rever_code =  db:lookup(cand.text)  or "----" -- get text
			end 
			--  進行 comment 字串轉換
			if (rever_coder ~= "" ) then
				cand:get_genuine().comment = cand.comment .. " " .. func(rever_code):gsub(" ","/") 
			end 
		else 

			-- tostring( xform_func )
		end 
		yield(cand) 
		-- 超出反查數量  放棄反查 
		cand_count = cand_count -1
		if  0 == cand_count  then  
			break
		end 
	end
end

local function make( )
	local config_tab=require("comment_init")
	--trig_nkey,trig_pkey ,revdbs, offpattern,quick_code_key= requrie("comment_init") 

--table.revdbs= revdbss
--table.next_key="Control+9"   -- 正循環
--table.prev_key= "Control+8"  -- 負循環
--table.reverse_off="V-"       -- 開閉反查
--table.quick_code ="Control+0" -- 簡碼開關 
	-- base pattern{}  供 processor 設置  index_num  參考
	local base= #config_tab.revdbs +1   -- #  反杳字典數量  + 反查OFF 
	--- 建立 輸入字串反查 index_num  供 process  改寫 index_num 
	local pattern={}   -- 反查字典name  table 調出 反查 index_num  


	-- init pattern tabel 
	if config_tab.reverse_off then -- 設定不反查的pattern  index_num=0 不反查
		pattern[ config_tab.reverse_off ]=0
	end 
	for i,revdb in ipairs(config_tab.revdbs) do  -- 建立 pattern[ revdb.text 為KEY] 設定 反查字典 index
		if (revdb.text) then          -- 如果 text 是空 則 不加入 
			pattern[ revdb.text ]= i
		end 
	end 

	local function processor(key,env)   -- 攔截 trig_key  循環切換反查表  index_num  +1 % base   
		local kAccepted = 1
		local kNoop=2
		local engine = env.engine
		local context = engine.context

		--  正循環
		if key:repr() ==  config_tab.n_key then --     循環切換反查字典 0 off 
			index_num=  (index_num +1 ) % base 
			context:refresh_non_confirmed_composition()
			return kAccepted
			-- 反循環
		elseif key:repr() == config_tab.p_key then -- 
			index_num = (index_num -1 + base) % base 
			context:refresh_non_confirmed_composition() -- 刷新 filter data 
			return kAccepted
			-- 只顥示 最簡碼 
		elseif key:repr() == config_tab.quick_code_key then 
			quick_code_flag= not quick_code_flag
			context:refresh_non_confirmed_composition() -- 刷新 filter data 
			return kAccepted 
			-- 快碼字串比對  符合才進入修改 index_num 
		elseif "number"  == type( pattern[context.input] ) then   -- context.input 可調出 比對 快碼 符合
			index_num =  pattern[context.input]  or index_num     -- 如果 無值  時 不異動 index_num 
			context:clear()  -- 清除 contex data 
			return kNoop
		end 
		return kNoop
	end 


	local function filter(input,env) 
		local db= env.revdbs[index_num].db 
		local dbfile= env.revdbs[index_num].dbfile
		local reverse_func = env.revdbs[index_num].reverse_func
		--log.info( "index: " .. tostring(index_num) .. "  db:"..tostring(db) .. "  reverfunc: " ..tostring(reverse_func) )  
		reverse_lookup_filter(input,db,reverse_func)
	end 
	-- revdbs ( array ) : { db= reverse_dbname , text= pattern }
	local function init(env)  -- 建立 revdb: Array { { db , revtable},{db,revtable} ..... }
		env.revdbs= config_tab.revdbs or {} -- config_tab.revdbs 
		for i,revdb in ipairs(env.revdbs) do  -- revdbs(array) --revdb { dbname : dbname , text: pattern ,func: reverse_string  } 
		    revdb=revdb or {} 	
			--revdb.db= ReverseDb("build/" .. tostring(revdb.dbname) .. ".reverse.bin")  -- 開啟 reverse.bin 
			revdb.dbfile= revdb.dbfile  or "build/" .. revdb.dbname .. ".reverse.bin"
			revdb.db= ReverseDb(tostring(revdb.dbfile   or ""))  -- 開啟 reverse.bin 
			revdb.reverse_func= revdb.reverse_func or require("format2")( table.unpack( revdb.pattern or {} ) )  
		end 
		for i,revdb in ipairs(env.revdbs) do 
			
			--log.info( "recheck  env.revdbs  : "  )
		end 

		index_num = DEFAULT_INDEX or 0 
		env.revdbs[0]={}

	end 
	return { reverse = { init = init, func = filter } , processor = processor } 
end  

-- return  { db = ReverseDb(name) , revtable= xform_func } 

return make 
