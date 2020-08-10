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

	metatable(pattern_list)
	pattern_list:map(MPF):each ( function(elm)
		  print("----pattern function " , elm)
		  self:insert(elm) 
		  self._list:each(print)
	  end )

	self:_reset_filter_func() --  reset __filetr_on 
	self:set_status(init_status or false )
end 
function PSFilter:insert(pattern_func)
	if type(pattern_func) == "function" then 
		self._list:insert( pattern_func)
		return pattern_func
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
