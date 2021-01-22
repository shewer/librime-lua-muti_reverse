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

local FilterList=require 'muti_reverse/filterlist'
local PSFilter = Class("PSFilter",FilterList)

function PSFilter:_initialize(pattern_list, init_status) -- data :  List of pattern_str 

	self:_super("_initialize",pattern_list,init_status) 
	return true
end 


return PSFilter
