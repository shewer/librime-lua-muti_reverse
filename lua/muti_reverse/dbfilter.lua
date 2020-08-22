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

DBFilter = class("DBFilter",Filter) 
DBFilter._dblist=metatable()  -- class vairable
function DBFilter.Open()
	DBFilter._dblist:each( function(elm) elm:open() end )
end 

function DBFilter:_initialize(data,init_status)
	if data.dbname then
	    self._dbname=data.dbname 
		self._dbfile = data.dbfile or "build/" .. data.dbname .. ".reverse.bin"
		self._db= false

		DBFilter._dblist:insert(self) -- ins object to class vairable  
	end 
	self:_reset_filter_func() 
	self:set_status(init_status or false)
	return Filter.bypass
end 
function DBFilter.reset()
	DBFilter._dblist=metatable()
end 
function DBFilter:open()
	local open_flag
	open_flag, self._db=pcall(ReverseDb,self._dbfile)
	if  open_flag then 
		
		log.org_log.info("-------------------------------------------")
		log.info( string.format( " pcall: ReverseDb file is opened  , %s   dbprint: %s " ,open_flag, self._db  ) )
    else 
		log.warning( string.format( " pcall: open  ReverseDb file is  faile , %s   dbprint: %s " ,open_flag,self._db  ) )
		self._db=false
	end 
	self:_reset_filter_func() 
	self:on()

end 

function DBFilter:set_status(status)
	rawset(self,"_status", (self._db and status and  true) or false )
	--self._status = (self._db and status and true) or false  -- _dbopen and status( not nil or flase ) then set true true 
	self:_set_filter( )
	return self:status() 
end 

function DBFilter:_reset_filter_func()
	rawset(self,"__filter_on", self:_create_filter_function() )
	return self["__filter_on"]
end 
function DBFilter:_create_filter_function()
	if self._db then 
		return function(str, ...)
			local flag,newstr,oldstr = pcall(self._db.lookup, self._db,str)   -- func , self str 
			newstr = newstr or ""
			oldstr = oldstr or ""
			return newstr,str
		end
	else 
		return self.bypass

	end 
end 
--function DBFilter:status()
	--return self._db and self._switch
--end 

--return DBFilter

