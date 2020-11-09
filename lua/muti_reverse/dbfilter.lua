#! /usr/bin/env lua
--
-- dbfilter.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
--local Filter=require 'muti_reverse.Filter'
--DBFilter extend Filter
--    return  DBFilter object
--        dbfilename :  reverse_filename of string
--        init_status  :  bool   
--  
--  method    
--        :on()
--        :off()
--        :toggle()
--        :status()
--        :set_status( bool) 
--        :filter(string)
--        :open() 
local FFilter=require 'muti_reverse/ffilter'
local DBFilter = Class("DBFilter",FFilter) 

function DBFilter:_initialize(dbname,init_status)
	if type(dbname) ~= "string" then 
		error("( ".. __FILE__() .." : " .. __LINE__() .." ):" .. " dbname type error: expect string  ")
	end 
	self._dbname=dbname 
	self._db= ReverseDb( self:filename() ) 
	local func= (self._db and function (str) return self._db:lookup(str),str end ) or self.bypass 
	self:_super("_initialize", func,init_status) 
	return true
end 

function DBFilter:filename()
	return self:dbname() and   "build/" .. self:dbname() .. ".reverse.bin"
end 
function DBFilter:dbname()
	return self._dbname
end 
function DBFilter:dbstatus()
	return self:_db()  and true or false
end 

return DBFilter

