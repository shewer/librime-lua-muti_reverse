#! /usr/bin/env lua
--
-- comment_init.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--


comment_whileliu=require("format")(  
	"xlit|~dmatwfyzljxiekbhsocrugqnpv[];,|～日月金木水火土竹戈十大中一弓人心手口尸廿山女田糸卜魚左右虫羊|"   ,
    [[ "xform/(.*)/($1)鯨/" ]]
	)
comment_luna_pinyin= function (str) return str end
comment_newcjliu=require("format")(
     "xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
	 [[ "xform/(.*)/($1)新/" ]]
)
comment_cangjie5liu=require("format")(
	 "xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 [[ "xform/(.*)/($1)倉/" ]]
)
comment_cangjie6liu=require("format")(
	 "xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜符～|",
	 [[ "xform/(.*)/($1)蒼/" ]]
)
comment_terra_pinyin=require("format")(
   "func/terra_pinyin/",
 [[ "xform/(.*)/($1)拼/" ]]

)
-- 從 comment_tab.lua  導出    key= { dbname="dbname" , pattern : { comment_format} }
-- 因為 pattern 是 Array  所以要用 table.unpack 
-- reverse_lookup_filter: 依地球拼音为候选项加上带调拼音的注释
-- 详见 `lua/reverse_switch.lua`
--  return  { reverse= {init=func, func=filter_func } , processor=func  }
--  require 'reverse_switch.lua' ( trig_key , reverse.bin ........) 
--  
--
--  建立反查字典參數
local revdbss={ -- 反查字典名  ， 快速切換輸入字串 , 反查函式 
	{dbname="whaleliu",text="Vw",	reverse_func=comment_whileliu },
	{dbname="luna_pinyin",		text="Vp",	reverse_func=comment_luna_pinyin },
	{dbname="terra_pinyin",		text="Vt",  reverse_func=comment_terra_pinyin},
	{dbname="newcjliu",			text="Vn",  reverse_func=comment_newcjliu },
	{dbname="cangjie5liu",		text="Vc",  reverse_func=comment_cangjie5liu },
	{dbname="cangjie6liu",		text="Vj",  reverse_func=comment_cangjie6liu },    --  {db= "terre_pinyin" }    表  沒有快碼
--	{dbname="cangjie5"	,		text="VC", 	reverse_func=comment_cangjie5 },  -- 從 comment_tab  轉出comment_cangjie5 
    require("comment_tab")( "cangjie5_reverse_lookup","VC"),
    require("comment_tab")( "cangjie6","VJ"),
	--require("comment_func")("terra_pinyin2","Vc"),

}
-- nexthot key,prevhot key, revdbs , 關閉反查字串 , 簡碼開關熱鍵
-- return 
local table={}
table.revdbs= revdbss
table.n_key="Control+9"   -- 正循環
table.p_key= "Control+8"  -- 負循環
table.reverse_off="V-"       -- 開閉反查
table.quick_code_key ="Control+0" -- 簡碼開關 

return table

