#! /usr/bin/env lua
--
-- pfilter.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
-- PFilter extend Filter 
-- PFilter obj  PFilter:new( pattern_str ,init_status )
--        pattern_str  : string   參見 schema xlit xfrom xderive .....
--        init_status  : bool 
--    return  PFilter object
--  method    
--        :onn()
--        :off()
--        :toggle()
--        :status()
--        :set_status( bool) 
--        :filter(string)
--
--    PFilter.Make_pattern( pattern_str)   -- class method 
--    return  filter func 
--        pattern_str : string 
--
--    example:
--        PFilter.Make_pattern( "xlit|abcd|ABCD|" )
--        
--



local FFilter = require 'muti_reverse/ffilter'

local PFilter = Class("PFilter",FFilter)

--FFilter.Make_pattern_func=make_pattern_func   -- class method 
function PFilter:_initialize(pattern_str ,init_status)
	local func=self.Make_pattern_func( pattern_str)  -- 
	if func then 
		self:_super("_initialize",func,init_status) 
	else 
	   --func=self.bypass
	   --log.warning( ("%s %s %s : (%s) can't create function "):format(__FILE__(),__FUNC__(),__LINE__(),str) ) 
	   return nil
   end 
   return true
	--self:class():class()._initialize(self,func,init_status) 
	--self:super(__FUNC__(), func,init_status )   -- call  FFilter:initialize(func,init_status ) 
end 
return PFilter



