#! /usr/bin/env lua
--
-- reverse_init.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--


-- bopomofo  filterlist     { reversedb_filter  , qcodefilter, reverse_filter }
local ON=true
local OFF=false
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
function candinfo(self)


end 
local _tab={
	switch=Switch:new(),   
	filter_switch=FilterList_switch:new()  ,
	qcode= FFilter:new(require('muti_reverse.qcode') ,ON),
	dbfile=DBFilter,
	--candinfo=FFilter:new(candinfo,false)  ,
	--comment_off =FFilter:new(disenable_completion,false),
	--qcode=FFilter:new(require('muti_reverse.qcode') ,false),

}
local function init_reverfilter(elm,i )
	-- 設定 及註冊 主副反查字典   
	--schema:each( function( elm,i) 
		local revf=_tab 
		local switch=revf.switch
		local filter_switch=revf.filter_switch

		local hotkey= elm.hotkey=="" and nil or elm.hotkey -- 空字串  設 nil
		local text = elm.text== "" and  "V".. tostring(i) or elm.text -- 空字串 設  V1 ..... Vn 
		switch:remove_key(hotkey)
		switch:remove_text(text)

		local dbf= DBFilter:new({dbname=elm.dbname} ,ON) 
		local qcode= revf.qcode
		local psf=PSFilter:new(elm.pattern,ON) 
		local flist = FilterList:new({dbf,qcode,psf} ,ON) -- ReverseDb  qcode 轉碼 串在一起
		flist:name(elm.dbname) 
		-- insert  & reg 
		filter_switch:insert(flist) -- 加入 反查字典 切換開關
		switch:insert({hotkey= hotkey ,text=text  ,obj=filter_switch,method="set_filter",argv=flist}) -- 註冊 熱鍵 快鍵
end 

--  reverse filter  init 
function _tab:open_revdb(schema )   --  env 空值時 可以自設
	--self.dbfile= Dbfilter
	if not schema then 
		log.info( string.format("schema is nil  defalult load schema form : schema_sim" )) 
		schema = require('muti_reverse.schema_sim')    -- 自設  檔也可改檔名  資料格式 依此檔
	end 
	-- 註冊 hotkey & text 
	self.schema=metatable(schema )
	-- 增加 獨立 主字典反查 用於 簡碼提示功能
	self.mainfilter= FilterList:new {
		DBFilter:new(schema[1] ,ON), 
		FFilter:new(require('muti_reverse.qcode') ,ON),
		psf=PSFilter:new(schema[1].pattern,ON),
	}

	self.dbfile.reset()
	self.filter_switch:reset()

	-- 設定 及註冊 主副反查字典   
	--schema:each( function( elm,i) 
	self.schema:each(init_reverfilter    ) -- func(elm,index) 
	
	self.dbfile.Open() -- open RevseDb


	FILTER= FILTER or self.filter_switch
	--self.DBFilter.Open()
end 




-- reverse init func -- open ReverseDb 
return  metatable(_tab)




