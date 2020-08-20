#! /usr/bin/env lua
--
-- reverse_init.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--


-- bopomofo  filterlist     { reversedb_filter  , qcodefilter, reverse_filter }

require 'muti_reverse'
--
-- 
	

--switch:insert({hotkey="Control+0", text=nil,obj=qcode,method="toggle",argv=nil})
--switch:insert({hotkey="Control+9", text=nil,obj=filter_switch,method="next",argv=nil})
--switch:insert({hotkey="Control+8", text=nil,obj=filter_switch,method="prev",argv=nil})
--switch:insert({hotkey="Control+7", text="VV",obj=filter_switch,method="toggle",argv=nil})
----switch:insert({hotkey="Control+6", text="Vq",obj=check_flag,method="toggle",argv="enable_completion"})
--switch:insert({hotkey=nil        , text="Vd",obj=check_flag,method="toggle",argv="debug"})
--switch:insert({hotkey="Control+6", text="Va",obj=check_flag,method="toggle_completion",argv="cangjie5liu"})
---- 設定
--switch:insert({hotkey=nil,text="Vw",obj=filter_switch,method="set_filter",argv=whaleliu_filter})
--switch:insert({hotkey=nil,text="Vn",obj=filter_switch,method="set_filter",argv=newcjliu_filter})
--switch:insert({hotkey=nil,text="V1",obj=filter_switch,method="set_filter",argv=bopomofo_filter})
--switch:insert({hotkey=nil,text="V2",obj=filter_switch,method="set_filter",argv=terra_pinyin_filter })
--switch:insert({hotkey=nil,text="V3",obj=filter_switch,method="set_filter",argv=cangjie5_filter })
--switch:insert({hotkey=nil,text="V4",obj=filter_switch,method="set_filter",argv=cangjie6_filter })

local function candinfo_func(cand)
	return string.format("( t:%s s:%2d e:%2d q:%5.2f } ",cand.type,cand.start,cand._end,cand.quality)  
end 
local function disenable_completion(cand) 
	return "",str
end 
--[[
--  candinfo filter 
local candinfo=FFilter:new( candinfo_func,false)  
 --comment_off   filter 
local comment_off =FFilter:new(disenable_completion,false)
--ENV= ENV or false
 --簡碼 filter
local qcode=FFilter:new(require('muti_reverse.qcode') ,false)
local switch=Switch:new(),   
local filter_switch=FilterList_switch:new() 
--]]


local _tab={
	switch=Switch:new(),   
	filter_switch=FilterList_switch:new()  ,
	candinfo=FFilter:new(candinfo,false)  ,
	comment_off =FFilter:new(disenable_completion,false),
    qcode=FFilter:new(require('muti_reverse.qcode') ,false),
	dbfile=DBFilter,
	
}
--  reverse filter  init 
function _tab:open(schema )   --  env 空值時 可以自設
	schema = schema or require('muti_reverse.schema_sim')    -- 自設  檔也可改檔名  資料格式 依此檔
	metatable(schema)
	-- 註冊 hotkey & text 
	self.schema=schema 
    -- 增加 獨立 主字典反查 用於 簡碼提示功能
	self.mainfilter= FilterList:new {
		DBFilter:new(schema[1] ,true ), 
		FFilter:new(require('muti_reverse.qcode') ,true),
		psf=PSFilter:new(schema[1].pattern,true),
	}

	local switch= self.switch
	local qcode=self.qcode 
	local filter_switch=self.filter_switch
	switch:insert({hotkey="Control+0", text="Vq",obj=qcode,method="toggle",argv=nil})    -- 短碼開關
	switch:insert({hotkey="Control+9", text=nil,obj=filter_switch,method="next",argv=nil}) -- 下一反查
	switch:insert({hotkey="Control+8", text=nil,obj=filter_switch,method="prev",argv=nil}) -- 上一反查
	switch:insert({hotkey="Control+7", text="VV",obj=filter_switch,method="toggle",argv=nil}) -- 反查開關
	switch:insert({hotkey="Control+6", text="Va",obj=candinfo,method="toggle",argv=nil}) -- comment開關
	switch:insert({hotkey="Control+5", text="Vd",obj=comment_off,method="toggle",argv=nil}) -- canddata 開關

	-- 設定 及註冊 主副反查字典   
	--schema:each( function( elm,i) 
	self.schema:each( function( elm,i) 

		local hotkey= elm.hotkey=="" and nil  -- 空字串  設 nil
		local text = elm.text== "" and  "V".. tostring(i)  -- 空字串 設  V1 ..... Vn 
		local dbf= DBFilter:new({dbname=elm.dbname} ,true ) -- {dbname="字典檔名" } ex"{dbname="cangjie5" } ==> cangjie5.reverse.bin
		local psf=PSFilter:new(elm.pattern,true) -- { "pattern1", "pattern2" .....} 
		
		local flist = FilterList:new({dbf,qcode,psf} ,true ) -- ReverseDb  qcode 轉碼 串在一起
	    -- insert  & reg 
		filter_switch:insert(flist) -- 加入 反查字典 切換開關
		switch:insert({hotkey= hotkey ,text=txet  ,obj=filter_switch,method="set_filter",argv=filst}) -- 註冊 熱鍵 快鍵
	end )


	 self.dbfile.Open() -- open RevseDb
	 --self.DBFilter.Open()
 end 




-- reverse init func -- open ReverseDb 
return  metatable(_tab)




