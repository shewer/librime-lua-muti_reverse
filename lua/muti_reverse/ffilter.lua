#! /usr/bin/env lua
--
-- ffilter.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
-- FFilter extend Filter 
-- FFilter   function Filter
-- FFilter:new( func,init_status ) 
--    return  PSFilter object
--        func :   function(str) return str,str 
--        init_status  :  bool   
--     
-- FFilter methods
--  method    
--        :onn()
--        :off()
--        :toggle()
--        :status()
--        :set_status( bool) 
--        :filter(string)
--
--
-- example :
-- local function upcase(str)
--     return str:upper(), str
-- ennd 
-- local upcasefilter= FFilter:new(upcase , true) 
--
-- upcasefilter= FFilter:new(upcase,true) -- 
-- upcasefilter=nil    -- delete 
-- 


local Filter=require 'muti_reverse/filter'

local FFilter = Class("FFilter",Filter)
FFilter.Make_pattern_func= require 'muti_reverse/pattern' -- return  pattern conver func 
function FFilter:_initialize(func, init_status ) -- data :  List of pattern_str 
	func=  (type(func) == "function" and func) or self.bypass 
	self:_filteron_func(func) 
	self:set_status(init_status)  -- set status and redirection _filter_func 
	return true
end 

return FFilter

