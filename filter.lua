#! /usr/bin/env lua
--
-- filter.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
--  Filter abstract class  extend Object 
--
--  method    
--        :onn()
--        :off()
--        :toggle()
--        :status()
--        :set_status( bool) 
--        :filter(string)
--
require 'tools/object' 
local Filter= Class("Filter") 

print("Filter:",type(Filter),"Class:" , Class,"Object" ,Object)


function Filter.Parse(filter)
	local FFilter= require 'muti_reverse/ffilter'
	local PFilter= require 'muti_reverse/pfilter'
	local PSFilter= require 'muti_reverse/psfilter'
	local FilterList=require 'muti_reverse/filterlist'
	local _type= type(filter)
	local elm 

	if _type == "string" then -- string try to create func
		elm=PFilter(filter,true)
		
	elseif _type== "function" then 
		elm=FFilter(filter,true)

	elseif _type:match("%u[%a_]+") and filter:is_a("Filter") then 
		elm= filter
	elseif _type== "table" then 
		elm=FilterList(filter,true)
	else 
		return nil
	end 
	return elm
end 

	
function Filter.bypass(str)    -- class method
	return str or  "" ,str   
end 
function Filter.null(str)
   return "",str
end 



function Filter:_initialize( data ,init_status) 
	if self == Filter  then 
		error( "--- abstract class----")
	end 
	self:set_status(init_status or false ) 
	return true
end 
function Filter:filter(text) 
	return  self._filter_func(text)
end 

function Filter:filteroff_pass()
	self:_filteroff_func(self.bypass)
end 
function Filter:filteroff_null()
	self:_filteroff_func(self.null)
end 


function Filter:toggle()
	return self:set_status( not self:status() )
end 
function Filter:on()
	return self:set_status(true)
end 
function Filter:off()
	return self:set_status(false)
end 
function Filter:status()
	return self._status 
end 
function Filter:set_status(status)
	self._status= status or false 
	self:_set_filter( )
	return self:status() 
end 
-- private 
function Filter:_filteroff_func(func)
	self.__filter_off=func
end
function Filter:_filteron_func(func)
	self.__filter_on=func
end
function Filter:_set_filter()
	local func -- = function(str) return str,str end 
		         
	print( "------- in set_filter() -----" )
	if self:status() then 

		 func= self.__filter_on or self.bypass-- redirection  func  point 
		 print("---- set_filter() , status== true  __filter_on ", func )


		 --[[
		 
         --func= function(str) return str,str end  -- reset  _filter_func when cheng status 
		 
		 --]]
	else 
		 
		 func= self.__filter_off or  self.bypass
		 print("----- status false  set func= bypass",fnuc)

	end 
	rawset(self, "_filter_func", func )  -- _reset_filter()  return new func to _filter 
	

end 

--class = class or {Object=Object}
--class.Filter=Filter

return Filter

