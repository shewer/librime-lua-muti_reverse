#! /usr/bin/env lua
--
-- reverse_switch.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--


--[[
reverse_lookup_filter: 依地球拼音为候选项加上带调拼音的注释

本例说明了环境的用法。
--]]

-- 帮助函数（可跳过）
--
local function xform_newcjliu(inp)
	return inp:gsub("a","金"):
	gsub("b","人"):
	gsub("c","尸"):
	gsub("d","日"):
	gsub("e","一"):
	gsub("f","火"):
	gsub("g","女"):
	gsub("h","心"):
	gsub("i","中"):
	gsub("j","十"):
	gsub("k","弓"):
	gsub("l","戈"):
	gsub("m","月"):
	gsub("n","難"):
	gsub("o","口"):
	gsub("p","卜"):
	gsub("q","田"):
	gsub("r","廿"):
	gsub("s","手"):
	gsub("t","木"):
	gsub("u","山"):
	gsub("v","言"):
	gsub("w","水"):
	gsub("x","大"):
	gsub("y","土"):
	gsub("z","竹"):
	gsub(",","，"):
	gsub(";","；"):
	gsub("'","、"):
	gsub("?","？"):
	gsub("/","／"):
	gsub("[.]","．"):
	gsub("^(.*)$","(%1)新")
end 

local function xform_cangjie6liu(inp)
	return inp:gsub("a","金"):
	gsub("b","人"):
	gsub("c","尸"):
	gsub("d","日"):
	gsub("e","一"):
	gsub("f","火"):
	gsub("g","女"):
	gsub("h","心"):
	gsub("i","中"):
	gsub("j","十"):
	gsub("k","弓"):
	gsub("l","戈"):
	gsub("m","月"):
	gsub("n","止"):
	gsub("o","口"):
	gsub("p","卜"):
	gsub("q","田"):
	gsub("r","廿"):
	gsub("s","手"):
	gsub("t","木"):
	gsub("u","山"):
	gsub("v","符"):
	gsub("w","水"):
	gsub("x","大"):
	gsub("y","土"):
	gsub("z","竹"):
	gsub(",","，"):
	gsub(";","；"):
	gsub("'","、"):
	gsub("?","？"):
	gsub("/","／"):
	gsub("[.]","．"):
	gsub("^(.*)$","(%1)蒼")
end 
local function xform_cangjie5liu(inp)
	return inp:gsub("a","金"):
	gsub("b","人"):
	gsub("c","尸"):
	gsub("d","日"):
	gsub("e","一"):
	gsub("f","火"):
	gsub("g","女"):
	gsub("h","心"):
	gsub("i","中"):
	gsub("j","十"):
	gsub("k","弓"):
	gsub("l","戈"):
	gsub("m","月"):
	gsub("n","難"):
	gsub("o","口"):
	gsub("p","卜"):
	gsub("q","田"):
	gsub("r","廿"):
	gsub("s","手"):
	gsub("t","木"):
	gsub("u","山"):
	gsub("v","符"):
	gsub("w","水"):
	gsub("x","大"):
	gsub("y","土"):
	gsub("z","竹"):
	gsub(",","，"):
	gsub(";","；"):
	gsub("'","、"):
	gsub("?","？"):
	gsub("/","／"):
	gsub("[.]","．"):
	gsub("^(.*)$","(%1)倉")
end 
local function xform_whaleliu(inp)
	return inp:gsub("a","金"):
	gsub("b","人"):
	gsub("c","尸"):
	gsub("d","日"):
	gsub("e","一"):
	gsub("f","火"):
	gsub("g","女"):
	gsub("h","心"):
	gsub("i","中"):
	gsub("j","十"):
	gsub("k","弓"):
	gsub("l","戈"):
	gsub("m","月"):
	gsub("n","糸"):
	gsub("o","口"):
	gsub("p","卜"):
	gsub("q","田"):
	gsub("r","廿"):
	gsub("s","手"):
	gsub("t","木"):
	gsub("u","山"):
	gsub("v","魚"):
	gsub("w","水"):
	gsub("x","大"):
	gsub("y","土"):
	gsub("z","竹"):
	gsub(",","羊"):
	gsub(";","虫"):
	gsub("'","、"):
	gsub("?","？"):
	gsub("/","／"):
	gsub("[.]","．"):
	gsub("^(.*)$","(%1)鯨")
end 

local function luna_pinyin_func(inp)
	return inp:gsub("^(.*)$","(%1)拼")
end 

--[[
如下，filter 除 `input` 外，可以有第二个参数 `env`。
--]]
--[[ 从 `env` 中拿到拼音的反查库 `pydb`。
`env` 是一个表，默认的属性有（本例没有使用）：
- engine: 输入法引擎对象
- name_space: 当前组件的实例名
`env` 还可以添加其他的属性，如本例的 `pydb`。
--]]

--[[
当需要在 `env` 中加入非默认的属性时，可以定义一个 init 函数对其初始化。
--]]
-- 当此组件被载入时，打开反查库，并存入 `pydb` 中

--[[ 导出带环境初始化的组件。
需要两个属性：
- init: 指向初始化函数
- func: 指向实际函数
--]]
--
-- 簡碼開關
local quick_code_flag=false 
-- index_num 共用變數  供  processor , filter 用 
local index_num=0    --   init index_num=0   反查 off  


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
local function reverse_lookup_filter(input, db,xform_func )
	local cand_count= CAND_MAX or 1000  -- 可在 rime.lua 設定 全域變數 CAND_MAX 最大反查數量
	local rever_code  -- 反查碼
	local revered_code  -- 字根轉碼
	for cand in input:iter() do
		if (db and xform_func ) then -- 反查字典 和  轉換函式不為空 
			--  quick_code  on /off 
			if quick_code_flag then 
				rever_code = quick_code( db:lookup(cand.text) )
			else 
				rever_code =  db:lookup(cand.text)  or "" -- get text
			end 
			if (rever_coder ~= "" ) then 
				cand:get_genuine().comment = cand.comment .. " " .. xform_func(rever_code):gsub(" ","/") 
			end 
		end 
		yield(cand) 
		-- 超出反查數量  放棄反查 
		cand_count = cand_count -1
		if  0 == cand_count  then  
			break
		end 
	end
end

local function make(trig_nkey,trig_pkey ,revdbs, offpattern,quick_code_key )  -- key , reverse db  name 


	-- base pattern{}  供 processor 設置  index_num  參考
	local base= #revdbs +1   -- #  反杳字典數量  + 反查OFF 
	--- 建立 輸入字串反查 index_num  供 process  改寫 index_num 
	local pattern={}   -- 反查字典name  table 調出 反查 index_num  


	-- init pattern tabel 
	if offpattern then -- 設定不反查的pattern  index_num=0 不反查
		pattern[offpattern]=0
	end 
	for i,revdb in ipairs(revdbs) do  -- 建立 pattern[ revdb.text 為KEY] 設定 反查字典 index
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
		if key:repr() ==  trig_nkey then --     循環切換反查字典 0 off 
			index_num=  (index_num +1 ) % base 
			context:refresh_non_confirmed_composition()
			return kAccepted
			-- 反循環
		elseif key:repr() == trig_pkey then -- 
			index_num = (index_num -1 + base) % base 
			context:refresh_non_confirmed_composition() -- 刷新 filter data 
			return kAccepted
			-- 只顥示 最簡碼 
		elseif key:repr() == quick_code_key then 
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
		local db= env.revdb[index_num].db
		local revtable= env.revdb[index_num].reverse_func
		reverse_lookup_filter(input ,db,revtable)  
	end 
	-- revdbs ( array ) : { db= reverse_dbname , text= pattern }
	local function init(env)  -- 建立 revdb: Array { { db , revtable},{db,revtable} ..... }
		for i,revdb in ipairs(revdbs) do  -- revdbs(array) --revdb { dbname : dbname , text: pattern ,func: reverse_string  } 
			revdb.db= ReverseDb("build/" .. tostring(revdb.dbname) .. ".reverse.bin")  -- 開啟 reverse.bin 
		end 
		index_num = DEFAULT_INDEX or 0 
		env.revdb=revdbs 
		env.revdb[0]={}

	end 
	return { reverse = { init = init, func = filter } , processor = processor } 
end  

-- return  { db = ReverseDb(name) , revtable= xform_func } 

return make 
