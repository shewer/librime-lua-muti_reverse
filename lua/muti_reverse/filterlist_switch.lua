#! /usr/bin/env lua
--
-- FilterList_switch.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
local FilterList= require 'muti_reverse/filterlist'
local FilterList_switch= Class("FilterList_switch",FilterList )

function FilterList_switch:_initialize(filter_lists,init_status)
	--self:class():class()[__FUNC__()](self,filter_list,init_status )  -- v1
	--self:class():class()._initialize(self,filter_list,init_status )  -- v2
	self:_super("_initialize",filter_lists,init_status)
	self._index=1
	FILTER = FILTER or self  -- init FILTER   string:filter() 
	return true
end 


function FilterList_switch:set_filter(obj)
	return self:set_index(  self:find_index(obj) )
end 

function FilterList_switch:next()
	return self:set_index( self:index() +1 ) 
end 
function FilterList_switch:prev()
	return self:set_index( self:index() -1 ) 
end 

function FilterList_switch:set_index(index)
	local base=#self:list()
	index= (tonumber(index) or self._index ) // 1
	self._index = (index  % base ) ==0  and base  or (index % base)  
	return self._index 
end 
function FilterList_switch:current_filter()
	return self:list()[ self:index() ]
end 


function FilterList_switch:index(index)
	return index and self:set_index(index) or self._index
end 
function FilterList_switch:_create_filter_function() --- override FilterList:_create_filter_function() 

	return function(str, ...)  -- create _filter function
		--log.info( 
			--string.format(  "debug funcname: %s,str: %s , obj: %s, index:%s , base:%s,%s", 
				--debug.getinfo(2,"lfSun").name , str, self, self:index() , self._base , #self:list() )  
			--)
		local fl= self:list()[self:index() ]  -- self:index()  get filter obj
		if fl then 
			return fl:filter(str, ...)
		else 
			log.warning( string.format("FilterList_switch: %s list:%s size:%s ,index:% ",
				self, self:list(), #self:list(), self:index()   ))
			return str,str   -- if  fl get nil  then  bypass 
		end 
	end 
end 


return FilterList_switch


