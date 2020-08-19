#! /usr/bin/env lua
--
-- FilterList_switch.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

FilterList_switch= class("FilterList_switch",FilterList )

function FilterList_switch:_initialize(filter_list,init_status)
	--self:class():class()[__FUNC__()](self,filter_list,init_status )  -- v1
	self:class():class()._initialize(self,filter_list,init_status )  -- v2
	self._index=1
	self._base=0
	FILTER = FILTER or self  -- init FILTER   string:filter() 
end 


function FilterList_switch:insert(filter) --  overrite  FilteList insert method 
	self:class():class().insert(self,filter)
	self._base= self._base + 1 
	return self._base 
end 

--function FilterList_switch:filter(str)
	--return self._list[self._index]:filter(str)
--end 
function FilterList_switch:find_index( obj)
	for i,v in ipairs(self._list) do
		if obj == v then  return i end 
	end 
    return nil 
end 
function FilterList_switch:set_filter(obj)
	local index = self:find_index(obj)
	if index then
		return self:set_index(index)
	else 
		return self._index
	end 
end 
function FilterList_switch:next()
	self._index =( self._index + self._base) % self._base  +1
	print(self._index)
	return self._index
end 
function FilterList_switch:prev()
	self._index = (self._index -1) % self._base 
	self._index = ( self._index <= 0 and self._base) or self._index 
	print(self._index)
	return self._index
end 

function FilterList_switch:set_index(index)
	self._index = index % self._base 
	return self._index
end 

function FilterList_switch:index()
	return self._index
end 
function FilterList_switch:_create_filter_function() --- override FilterList:_create_filter_function() 
	return function(str, ...)  -- create _filter function
		local fl =self._list[ self:index() ]
		return fl:filter(str,...) 
	end 
end 
function FilterList_switch:_set_filter() --  override Filter:set_filter()    bypass --> null 
	local func 
	if self:status() then 
		func= self.__filter_on
	else 
		func= self.null
	end 

	rawset(self, "_filter_func",func)
end 




