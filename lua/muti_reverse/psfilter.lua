#! /usr/bin/env lua
--
-- psfilter.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
-- PSFilter   extend PFilter 
-- PSFilter:new( patter_list ,init_status)
--    return  PSFilter object
--        pattern_list :   list of pattern_string  { "xlit ....", "xform ...", ....}
--        init_status  :  bool   
-- PSFilter methods
--  method    
--        :onn()
--        :off()
--        :toggle()
--        :status()
--        :set_status( bool) 
--        :filter(string)
--


PSFilter = class("PSFilter",PFilter)

function PSFilter:_initialize(pattern_list, init_status) -- data :  List of pattern_str 
	local MPF=self.Make_pattern_func -- PFilter class method 
	self._list= metatable()
	table.each( pattern_list,  function(elm)
		  self:insert(elm) 
	  end )

	self:_reset_filter_func() --  reset __filetr_on 
	self:set_status(init_status or false )
end 
function PSFilter:insert(pattern)
	if type(pattern) == "string" then 
	    pattern=self.Make_pattern_func(pattern)
	end 
	if type(pattern) == "function" then 
		self._list:insert( pattern)
		return pattern
	else 
		return nil
	end 
end 
function PSFilter:_reset_filter_func()
	rawset(self,"__filter_on", self:_create_filter_function() )
	return self["__filter_on"]
end 
function PSFilter:_create_filter_function()
	return function(str, ...)  -- create  _filter func 
		return self._list:reduce(function(elm,arg)   -- return filtered str 
			return elm(arg )
		end,
		str)
	end 
end 
