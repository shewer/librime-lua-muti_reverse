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
local DBFilter=require 'muti_reverse/dbfilter'
local QFilter=require 'muti_reverse/qcode'
local PSFilter=require 'muti_reverse/psfilter'
local FilterList=require 'muti_reverse/filterlist'
local FilterList_switch=require 'muti_reverse/FilterList_switch' 
local qcode_code= QFilter()

--local FL_Sw= Class("FL_Sw",FilterList_switch)
function FilterList_switch:get_current_info()
	local current_filter=self:current_filter()
	return   ("dbname:%s text:%s hotkey: %s tips:%s "):format(current_filter.dbname, current_filter.text, current_filter.hotkey, current_filter.tips) 

end 
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
function FilterList_switch:str_cmd(str) -- "switch:key:value" "switch:next","switch:index:1"
	print(str)
	local chk,cmd,value1,value2= str:split(":"):unpack()
	--print( ("chk %s , cmd: %s , value1: %s value2: %s "):format( chk,cmd,value1,value2 ) )
	if chk== "switch" then 
		if cmd == "next" or cmd == "prev" then 
			return self[cmd](self)
		end 
		if cmd== "off" or cmd== "on" or cmd== "toggle" then 
			return self[cmd](self)
		end 
		if cmd== "index" then 
			return self:set_index( tonumber(value1) ) 
		end 
		return self:set_filter_key(cmd,value1)

	end 
end 
local Completion= Class("Completion")
function Completion:_initialize(translation,init_status)
	self._trans=translation
	self._status= init_status or false 

	return true 
end 
function Completion:status(flag)
	if flag == nil then  return self._status end 
	self._status = flag and true  or false 
	return self._status 
end 

function Completion:iter() 
	return coroutine.wrap( function()
		for cand in self._trans:iter() do 
			if self:check(cand)  then 
				coroutine.yield(cand)
			end 
		end 
	end )
end 
function Completion:check(cand) 
	if self:status() then 
		return not cand.type == "complation"    -- true yield cand
	else 
		return true    --  yield
	end 
end 




local function filter_init( schema_data )
	local tab=schema_data:map( function (elm)
		local dbfilter= DBFilter(elm.dbname,true)
		local psfilter= PSFilter(elm.patterns,true )
		local flist= FilterList({ dbfilter ,qcode_code,psfilter} ,true)
		flist.dbname= elm.dbname
		flist.text= elm.text
		flist.hotkey=elm.hotkey
		flist.tips=elm.tips 

		return flist 

	end )
	return FilterList_switch(tab),qcode_code ,Completion 
		
end 



return filter_init  -- return function ( schema_data)  return filterlist_switch, qfilter
