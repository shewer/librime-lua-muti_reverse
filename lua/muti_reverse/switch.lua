#! /usr/bin/env lua
--
-- switch.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
--local M = requrie 'muti_reverse'
Switch= class("Switch",Object)
--Switch=setmetatable( {_cname="Switch"},{__index=Object } )
function Switch:_initialize(table) --   dbs, nkey,pkey,rkey,qkey)
	self._texts={}
	self._hotkeys={}
	
end
function Switch:insert(tab)
	if tab.hotkey or tab.text then 
		print( "hotkey",tab.hotkey ,"text :",tab.text,tab.argv)
		if tab.hotkey then self. _hotkeys[tab.hotkey] = tab end 
		print( "hotkey",tab.hotkey ,"text :",tab.text,tab.argv)
		if tab.text then self._texts[tab.text]= tab end 
		return true 
	else 
	return false 
	end 
end 
function Switch:check_hotkey(key,env)
	local _hotkeys=self._hotkeys 
	if _hotkeys[key] then 
		local flag, res= pcall(_hotkeys[key].obj[ _hotkeys[key].method     ] , -- method
		_hotkeys[key].obj ,_hotkeys[key].argv,env )  -- self, argv

		if (not flag)  then log.info( " pcall fails  Switch  Hotkey :" .. key .. tostring(res) ) end 
		return flag
	else 
		return false 
	end 
end 
function Switch:check_text(text,env)
	local _texts=self._texts
	if _texts[text] then 
		 local flag,res= pcall(_texts[text].obj[  _texts[text].method     ] , -- method
		_texts[text].obj , _texts[text].argv,env )  -- self, argv
		if (not flag)  then log.info( " pcall fails  Switch  Hotkey :" .. text .. tostring(res) ) end 
		return flag
	else 
		return false 
	end 
end 

