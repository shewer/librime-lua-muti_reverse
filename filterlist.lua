#! /usr/bin/env lua
--
-- filterlist.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
-- FilterList extend Filter
--    return  FilterList object
--       filters_list:    list of filter {  filter_obj ,,,,,,}
--       init_status:   default  true   :on()
--  method    
--        :onn()
--        :off()
--        :toggle()
--        :status()
--        :set_status( bool) 
--        :filter(string)
local FFilter= require 'muti_reverse/ffilter'
--local PFilter= require 'muti_reverse/pfilter'
--local PSFilter= require 'muti_reverse/psfilter'

local FilterList= Class("FilterList",FFilter)

function FilterList:_initialize(filter_list,init_status )

	self._list=metatable()
	if filter_list and type(filter_list) =="table" then 
		--filter_list:each(print)
		for i,elm in ipairs(filter_list) do 
			  self:insert(elm) 
		end   
	else 
		print("empty")

		--error (string.format( "filter_list type error : %s",filter_list))  
	end 
	self:_filteron_func( self:_create_filter_function() )

	--self:_reset_filter_func() --  reset __filetr_on 
	self:set_status(init_status or true )    --- defalut on  
	return true

end 
function FilterList:insert(filter)
	if not filter then return nil end 
	local  f = self.Parse(filter)
	self._list:insert(f)
	return f
end



--[[
function FilterList:Parse(filter)
	local _type= type(filter)
	local elm 

	if _type == "string" then -- string try to create func
		filter =self.Make_pattern_func(filter)
		_type= type(filter)
	end 
		
	if _type== "function" then 
		elm=FFilter(filter,true)

	elseif type(filter):match("%u[%a_]+") and filter:is_a("Filter") then 
		elm= filter
	elseif _type== "table" then 
		setmetatable(filter)
	else 
		return nil
	end 
	return elm
end 
--]]
function FilterList:list()
	return self._list
end 

function FilterList:reset()
	self._list= metatable()
	return self:size()
end 
function FilterList:size()
	return #self:list()
end 

function FilterList:_create_filter_function()
	return function(str, ...)  -- create  _filter func 
		str=str or ""
		return self._list:reduce(function(elm,arg)   -- return filtered str 
			return elm:filter(arg )
		end,
		str   )   ,str
	end 
end 

return FilterList

