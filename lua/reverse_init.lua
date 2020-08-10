#! /usr/bin/env lua
--
-- reverse_init.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
--
log=log or require 'muti_reverse.log'  -- 如果 librime-lua 舊版 不支援 log  需要環境變數 TMP  路逕
require 'muti_reverse'
-- 簡碼 filter
local qcode=FFilter:new(require('muti_reverse.qcode') ,false)


-- r
-- reverdb    DBFilter:new( { dbname=string  , dbfile=string } , init_status ) 
--            PSFilter:new( { pattern_str_list ....  } , init_status )   pattern: xlit xform ...
--            FFilter:new( func , init_status )  --    function(str)  return newstr,str end 
--            FilterList:new( { Filter or func   }, init_status)  
--            FilterList_switch:new ( {Filter or func } , init_status) 
--
local luna_pinyin_db=DBFilter:new({dbname="luna_pinyin"},true)

-- 6yterra_pinyin ReverseDb filter
local terra_pinyin_db=DBFilter:new({dbname="terra_pinyin"},true)



-- get dbname andd pattern from  comment_func 
local bopomofo_tab=require( 'muti_reverse.comment_func')("bopomofo")
local bopomofo_db=DBFilter:new({dbname=bopomofo_tab.dbname},true)
-- terra_pinyin patterns filter 
local bopomofo_ps=PSFilter:new(bopomofo_tab.pattern,true)


local terra_pinyin_tab=require( 'muti_reverse.comment_func')('terra_pinyin_reverse_lookup')
local terra_pinyin_db=DBFilter:new({dbname=terra_pinyin_tab.dbname},true)
local terra_pinyin_ps=PSFilter:new(terra_pinyin_tab.pattern,true)


-- 
local cangjie5_db=DBFilter:new({dbname="cangjie5"},true)
local cangjie5_list= {
	"xform/$/〕=-/",
	"xform/^/〔/",
	"xlit|abcdefghijklmnopqrstuvwxyz~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
}
local cangjie5_ps=PSFilter:new(cangjie5_list,true)

local cangjie6_db=DBFilter:new({dbname="cangjie6.extended"},true)
local cangjie6_list= {
	"xform/$/〕=-/",
	"xform/^/〔/",
	"xlit|abcdefghijklmnopqrstuvwxyz |日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片、|",
}
local cangjie6_ps=PSFilter:new(cangjie6_list,true)




-- bopomofo  filterlist     { reversedb_filter  , qcodefilter, reverse_filter }
local bopomofo_filter= FilterList:new({terra_pinyin_db,qcode, bopomofo_ps },true )
local terra_pinyin_filter=FilterList:new({terra_pinyin_db,qcode,terra_pinyin_ps },true )
local cangjie5_filter=FilterList:new({cangjie5_db,qcode,cangjie5_ps},true)
local cangjie6_filter=FilterList:new({cangjie6_db,qcode,cangjie6_ps},true)


local whaleliu=require( 'muti_reverse.comment_func')('whaleliu')
local newcjliu=require( 'muti_reverse.comment_func')('newcjliu')
whaleliu_filter= FilterList:new( { DBFilter:new({dbname="whaleliu.extended"},true),qcode, PSFilter:new(whaleliu.pattern,true)} ,true)
newcjliu_filter= FilterList:new( { DBFilter:new(newcjliu,true),qcode, PSFilter:new(newcjliu.pattern,true)} ,true)

local filter_ar= metatable{ 
	
--whaleliu_filter,
--newcjliu_filter, 
bopomofo_filter,
terra_pinyin_filter,
cangjie5_filter,
cangjie6_filter,
}

local switch=Switch:new()
local filter_switch =FilterList_switch:new()
-- set string:filter handle 
--  FilteList_switch:new()   FILTER=filter_switch 
--- insert filters 
filter_ar:each(function(elm) filter_switch:insert(elm) end )
------ insert command
--
--  外掛 狀態
local check_flag=metatable()
function check_flag:toggle(flag_str)
	self[flag_str] = not  self[flag_str] 
end 
-- enable_completion 開關  (translator 要設定: true  由 filter 判斷 cand.type 
local function enable_completion(cand)
	if cand.type ~= "completion"  then return true  end   -- cand.comment =""  return ture
	return  check_flag["enable_completion"]   -- cand.comment not empty  return flag 
end 
-- debug 杳看 cand data  type start _end quility 
local function debug(cand)
	return ( check_flag["debug"] and 
	   string.format("( t:%s s:%2d e:%2d q:%5.2f } ",cand.type,cand.start,cand._end,cand.quality) ) or "" 
end 

switch:insert({hotkey="Control+0", text=nil,obj=qcode,method="toggle",argv=nil})    -- 短碼開關
switch:insert({hotkey="Control+9", text=nil,obj=filter_switch,method="next",argv=nil}) -- 下一個反查
switch:insert({hotkey="Control+8", text=nil,obj=filter_switch,method="prev",argv=nil}) -- 上一個反查
switch:insert({hotkey="Control+7", text="VV",obj=filter_switch,method="toggle",argv=nil}) -- 反查開關
-- 外掛 狀態 開關設定
switch:insert({hotkey="Control+6", text="Vq",obj=check_flag,method="toggle",argv="enable_completion"}) -- 
switch:insert({hotkey=nil        , text="Vd",obj=check_flag,method="toggle",argv="debug"})
-- 設定
--switch:insert({hotkey=nil,text="Vw",obj=filter_switch,method="set_filter",argv=whaleliu_filter})
--switch:insert({hotkey=nil,text="Vn",obj=filter_switch,method="set_filter",argv=newcjliu_filter})
switch:insert({hotkey=nil,text="V1",obj=filter_switch,method="set_filter",argv=bopomofo_filter}) -- 反查快鍵
switch:insert({hotkey=nil,text="V2",obj=filter_switch,method="set_filter",argv=terra_pinyin_filter }) -- 反查快鍵
switch:insert({hotkey=nil,text="V3",obj=filter_switch,method="set_filter",argv=cangjie5_filter })  -- 反查快鍵
switch:insert({hotkey=nil,text="V4",obj=filter_switch,method="set_filter",argv=cangjie6_filter }) -- 反查快鍵





local _tab={
	switch=switch,
	filter_switch=filter_switch ,
	--open= function()  dbfilter:each(function(elm) elm:open() end )  end,
	open=  DBFilter.Open,
	enable_completion=enable_completion ,
	debug=debug,

}
-- reverse init func -- open ReverseDb 
return  metatable(_tab)




