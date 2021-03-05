#! /usr/bin/env lua
--
-- filter_init.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
	--local keys=metatable( { 
		--dbname= {"dictionary", "string"},
		--patterns= {"preedit_format","list","string"},
		--patterns2={"comment_format", "list","string"},
		--text= {"textkey","string"},
		--hotkey= {"hotkey","string"},
		--tips={ "tips","string"},
	--})
require 'tools/metatable'
local FFilter=require 'muti_reverse/ffilter'

local DBFilter=require 'muti_reverse/dbfilter'
local QFilter=require 'muti_reverse/qcode'
local PSFilter=require 'muti_reverse/psfilter'
local FilterList=require 'muti_reverse/filterlist'
local FilterList_switch=require 'muti_reverse/filterlist_switch' 



-- candata  to  text  
local Candinfo_Filter=Class("Candinfo_Filter",FFilter)
function Candinfo_Filter:_initialize(init_status)
	self:_filteron_func( 
	function(cand)
			local candinfo = ("|t: %s s: %s e: %s q:%s c: %s p: %s"):format(cand.type,cand.start,cand._end,cand.quality,cand.comment,cand.preedit )
			return candinfo,cand 
	end )
	self:_filteroff_func( self.null ) --  status_off  return ""  
	self:set_status(init_status or false)
	return true 
end 



-- sort  reverse code  size 
local SortFilter=Class("SortFilter",FFilter)
function SortFilter:_initialize(init_status)
	self:_filteron_func(
	function(str) 
		local tab=str:split()
		tab:sort( function(a,b) return #a<#b end )
		return tab:concat(" ")  
	end)  
	self:set_status(init_status or true ) 
	return true
end 

-- 臨時增加  methods  取得 目前 filter的資料  reverdb ... 
--local FL_Sw= Class("FL_Sw",FilterList_switch)
function FilterList_switch:get_current_info()
	local current_filter=self:current_filter()
	return   ("dbname:%s text:%s hotkey: %s tips:%s "):format(current_filter.dictionary, current_filter.textkey, current_filter.hotkey, current_filter.tips) 

end 

-- update new method( str_cmd  for property_update_notifier() 
function FilterList_switch:set_filter_key(name,key)
	local index = self:index()
	for i,v  in pairs(self:list()) do 
		if v[name] == key then 
			index= i
			break
		end 
	end 
	return self:set_index(index)
end 
-- 增加字串命令 控制 filterlist_sw  next prev  off on  toggle  set index numer
function FilterList_switch:str_cmd(str) -- "switch:key:value" "switch:next","switch:index:1"
	print("-----i str_cmd : " , str )
	local chk,cmd,value1,value2= str:split(":"):unpack()

	print("chk:" , chk,"cmd:" ,cmd,"v1:", value1,"v2:" ,value2)

	--print( ("chk %s , cmd: %s , value1: %s value2: %s "):format( chk,cmd,value1,value2 ) )
	if chk== "switch" then 
		if cmd == "next" or cmd == "prev" then 
			 self[cmd](self)
		end 
		if cmd== "off" or cmd== "on" or cmd== "toggle" then 
			 self[cmd](self)
		end 
		if cmd== "index" then 
			self:set_index( tonumber(value1) ) 
		end 
		--return self:set_filter_key(cmd,value1)

	end 
end 

-- init  dictionary  function to string table 
-- initialize filter 
local function filter_init(schema_data, pattern_name ) -- pattern_name: preedit_format / comment_format 
	-- load schema_data
	--local init_data= require("muti_reverse/load_schema")  -- return function 
	--local schema_data = init_data(env) 

	local mtran= schema_data[1]
	local main_tran=FilterList({ DBFilter(mtran.dictionary,true) ,QFilter(true) } ,true) 
	local sortfilter= SortFilter(true)
	local qcode_code= QFilter()
	local candinfo= Candinfo_Filter()

	local tab=schema_data:select(
	function(elm) 
		return not elm["reverse_disable"] 
	end ):map( 
	function (elm)
		local dbfilter= DBFilter(elm.dictionary,true)
		local psfilter= PSFilter( elm[pattern_name] or elm["preedit_format"]  ,true )
		local flist= FilterList({ dbfilter ,sortfilter, qcode_code,psfilter} ,true)
		flist.dictionary= elm.dictionary
		flist.text= elm.text
		flist.hotkey=elm.hotkey
		flist.tips=elm.tips 

		return flist 

	end )
	local filterlist_sw=FilterList_switch(tab)
	filterlist_sw:filteroff_null() 
	
		-- init   env.filter,env.qcode, env.candinfo ,env.main_tran 
	
	return filterlist_sw,qcode_code ,candinfo,main_tran
		
end 



return filter_init  -- return function ( env, pattern_name)  return filterlist_switch, qfilter
