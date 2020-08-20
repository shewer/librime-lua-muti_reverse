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

FilterList= class("FilterList",Filter)
function FilterList:_initialize(filter_list,init_status )

	self._list=metatable()
	if filter_list and type(filter_list) =="table" then 
		metatable(filter_list)
		filter_list:each(print)
		filter_list:each( function(elm )  self:insert(elm) end   )
	else 
		print("empty")
		--error (string.format( "filter_list type error : %s",filter_list))  
	end 
	self:_reset_filter_func() --  reset __filetr_on 
	self:set_status(init_status or true )    --- defalut on  

end 

function FilterList:insert(filter)
	local _type= type(filter)
	local elm 
	if _type== "function" then 
		elm=FFilter:new(filter,true)
	--elseif _type == "table" and filter.filter then 
	elseif filter:is_a(Filter) then 
		elm= filter
	else 
		return nil
	end 
	self._list:insert(elm )
	self._filter= self:_create_filter_function() 
	return elm
end 
function FilterList:list()
	return self._list
end 
function FilterList:_reset_filter_func()
	rawset(self,"__filter_on", self:_create_filter_function() )
	return self["__filter_on"]
end 
function FilterList:_create_filter_function()
	return function(str, ...)  -- create  _filter func 
		return self._list:reduce(function(elm,arg)   -- return filtered str 
			return elm:filter(arg )
		end,
		str)
	end 
end 
