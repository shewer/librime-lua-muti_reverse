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
	FILTER = FILTER or self  -- init FILTER   string:filter() 
end 


function FilterList_switch:insert(filter) --  overrite  FilteList insert method 
	self:class():class().insert(self,filter)
	return #self:list() 
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
	local base= #self:list()
	local index= self:index()
	self._index =( index + base) % base  +1
	return self:index() 
end 
function FilterList_switch:prev()
	local base= #self:list()
	local index= self:index()
	self._index = (index -1 ) <= 0 and  base  or (index-1)
	return self:index()
end 

function FilterList_switch:set_index(index)
	local base=#self:list()
	local index= self:index()
	self._index = (index % base ) ==0  and base  or (index % base)  
	return self:index() 
end 

function FilterList_switch:index()
	return self._index
end 
function FilterList_switch:_create_filter_function() --- override FilterList:_create_filter_function() 

	return function(str, ...)  -- create _filter function
		--log.info( 
			--string.format(  "debug funcname: %s,str: %s , obj: %s, index:%s , base:%s,%s", 
				--debug.getinfo(2,"lfSun").name , str, self, self:index() , self._base , #self:list() )  
			--)
		local fl= self:list()[self:index() ]
		if fl then 
			return fl:filter(str, ...)
		else 
			log.warning( string.format("FilterList_switch: %s list:%s size:%s ,index:% ",
				self, self:list(), #self:list(), self:index()   ))
			return str,str   -- if  fl get nil  then  bypass 
		end 
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




