#! /usr/bin/env lua
--
-- Dbs.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

--local Objject=requrie 'muti_reverse.object'

--Dbs=setmetatable( {_cname="Dbs" },{__index=Object } ) 
Dbs=class("Dbs",Object)
function Dbs:_initialize(table)
	self._index=init_index or 0
	self._base=1
	--self._quick_code_flag=false
	self._dbs=metatable(table) 
	self._dbs:each (function(db) self:insert(db) end ) 
	self.filters= metatable()


end 
function Dbs:inspect()
	return self._index, self._dbs[ self._index ] 
end 
function Dbs:insert( db )
	self._dbs:insert(db)
	self._base = self._base + 1
	return self._base
end 
function Dbs:cmdlist()
	return self._dbs:map(function(v,i) return v._text end )
end 
function Dbs:filter(text)
	if self._index==0 then 
		return text,text
	end 
	return self._dbs[self._index]:filter_list():reduce(
	    function(elm,org) 
			return elm:filter(org)     
		end,text   )
end 
function Dbs:next()
	self._index =(self._index+1 +self._base) % self._base
	return self._index
end 
function Dbs:prev()
	self._index =(self._index-1 +self._base) % self._base
	return self._index
end 
function Dbs:set_index(n)
	self._index=  ( n + self._base ) % self._base
	return self._index
end 
function Dbs:reset()
	self._index= 0
	return self._index
end 
function Dbs:quick_code_toggle()
	return self._dbs[self._index]:quick_code_toggle() 
end 
--   
--function string:filter(func)
	--return (func and func(self)) or self,self
--end 
--return Dbs
