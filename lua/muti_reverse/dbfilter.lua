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
DBFilter._dbfilterlist=metatable()
function DBFilter.Open()
	DBFilter._dbfilterlist:each( function(elm) elm:open() end )
end 

function DBFilter:_initialize(data,init_status)
	if type(data.dbname) ~= "string" then 
		error("( ".. __FILE__() .." : " .. __LINE__() .." ):" .. " dbname type error: expect string  ")
	end 
	self._dbname=data.dbname 
	self:_init_db()
	
	self:_reset_filter_func() 
	self:set_status(init_status or false)
end 

function DBFilter:_init_db()
	self:class()._dblist[self:name()]  = (self:_db() == nil and false) or self:_db() 
	self:class()._dbfilterlist:insert(self)
end 
function DBFilter.reset()
	DBFilter._dblist=metatable()
end 
function DBFilter:filename()
	return self:name() and   "build/" .. self:name() .. ".reverse.bin"
end 
function DBFilter:name()
	return self._dbname
end 
function DBFilter:dbstatus()
	return self:_db()  and true or false
end 
function DBFilter:_db()
	return self:class()._dblist[ self:name()]
end 
function DBFilter:open()
	local open_flag
	local df=self._dblist 
	local dbname=self:name()
	if not self:dbstatus()  then
		open_flag, df[dbname]=pcall(ReverseDb, self:filename() )
	else 
		open_flag=true
	end 
	if  open_flag then 
		log.org_log.info("-------------------------------------------")
		log.info( string.format( " pcall: ReverseDb file is opened  , %s   dbprint: %s " ,open_flag, self:_db()  ) )
    else 
		log.warning( string.format( " pcall: open  ReverseDb file is  faile , %s   dbprint: %s " ,open_flag,self:_db()  ) )
		df[dbname]=false
	end 
	self:_reset_filter_func() 
	self:on()

end 

function DBFilter:set_status(status)
	rawset(self,"_status", ( self:dbstatus()   and status and  true) or false )
	--self._status = (self._db and status and true) or false  -- _dbopen and status( not nil or flase ) then set true true 
	self:_set_filter( )
	return self:status() 
end 

function DBFilter:_reset_filter_func()
	rawset(self,"__filter_on", self:_create_filter_function() )
	return self["__filter_on"]
end 
function DBFilter:_create_filter_function()

	if self:dbstatus()  then 

		return function(str, ...)
			local revdb= self:_db()
			local newstr,oldstr=str,str
			local flag,newstr = pcall(revdb.lookup, revdb, str)   --  revdb.lookup , self , str => revdb:lookup(str)  
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

