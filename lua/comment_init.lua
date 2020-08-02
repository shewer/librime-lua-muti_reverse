#! /usr/bin/env lua
--
-- comment_init.lua
-- Copyright (C) 2020 jShewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

-- 從 comment_tab.lua  導出    key= { dbname="dbname" , pattern : { comment_format} }
-- 因為 pattern 是 Array  所以要用 table.unpack 成 ... 
--  
--
--  建立反查字典參數
--  
local comment_func=require("comment_func")

-- 訂定 反查方案  
-- 詳細 請見 commetn_func: 設定 反杳方案 及 初值設定 
--               comment_tab:  從 build/schema 調出 comment_format & dbname 
--               format2:      將 pattern 轉置成  reverse_func 
--
-- revdbss (array) {  { dbname, dbfile, text, reverse_func } {} ..... }
--
-- comment_func   調出 {dbname,dbfile,text,reverse_func } 
local mk_patterns,mk_pattern= require('format2')()
local comment_whaleliu= mk_patterns(
	--pattern= {
		"xlit|~dmatwfyzljxiekbhsocrugqnpv[];,|～日月金木水火土竹戈十大中一弓人心手口尸廿山女田糸卜魚左右虫羊|"   ,
		"xform/(.*)/($1)鯨/"
	--}
)

local revdbs={ -- 反查字典名  ， 快速切換輸入字串 , 反查函式 

	--comment_func("whaleliu_ext","VW"),
	comment_func("whaleliu","Vw"),
	comment_func("newcjliu","Vn"),
	comment_func( "cangjie5liu","Vc"),
	comment_func( "cangjie6liu","Vj"),
    comment_func( "bopomofo","Vp"),
    comment_func("terra_pinyin_reverse_lookup"),
	-- 手動設定也可以 
	{ dbname="whaleliu",dbfile="build/whaleliu.reverse.bin",text="VW",	reverse_func = comment_whaleliu },

}
--Object={}
--function Object:new(o)
	--o= o or {}
	--setmetatable(o,self)
	--self.__index= self
	--return o
--end 



--Array={}
--function Array:new(o)
	--jo= o or Object:new(o) 
	--self.__index=Object 
	--return o
--end 
--Hash={}

--function table.each(self,func,_type) 
	--if _type then 
		--local itor= ipairs(self)
	--else 
		--local itor= pairs(self)
	--end 
	--for k,v in itor() do
		--func(v,k)
	--end 
	--return self
--end 
--function table.map(self,func,_type) 
	--local tab=Table:new() 
	--if _type then 
		--local itor= ipairs(self)
	--else 
		--local itor= pairs(self)
	--end 
	--for k,v in itor() do
		--tab:inert( func(v,k) )
	--end 
	--return tab 
--end 


-- nexthot key,prevhot key, revdbs , 關閉反查字串 , 簡碼開關熱鍵
-- return 
local table={}
table.revdbs= revdbs
table.n_key="Control+9"   -- 正循環
table.p_key= "Control+8"  -- 負循環
table.reverse_off="V-"       -- 開閉反查
table.quick_code_key ="Control+0" -- 簡碼開關 

-- test function   
-- lua -l comment_init -e ' test() '
-- lua -l comment_init -e ' test("abc","abct toeu") '
function test(...)
	local teststr
	if ... then 
		teststr= {...}
	else
		teststr={ "ban4 fa3","teo", "abc", "abe toeu "}
	end 
	print("table.n_key",table.n_key)
	print("table.p_key",table.p_key)
	print("table.reverse_off",table.reverse_off)
	print("table.quick_code_key",table.quick_code_key)

	for i,str  in ipairs(teststr) do
		print("--------------------")
		print("test : ",i,"test  string :", str )
		print("--------------------")

		for i,v in ipairs(table.revdbs) do
			if v.reverse_func then 
				print("index: " .. i , v.text,  v.dbname,"(", v.dbfile, ")".. ": " , v.reverse_func(str))
			else
				print("error : index: " .. i , v.text,  v.dbname,"(", v.dbfile, ")".. ": " , v.reverse_func)
			end 

		end 

	end 
end
return table

