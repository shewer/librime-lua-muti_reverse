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
Filter= class("Filter",Object) 
function Filter.bypass(str)    -- class method
	return str,str
end 
function Filter.null(str)
   return "",str
end 



function Filter:_initialize( data ,init_status) 
	self:_subinit(data)
	error( "--- abstract class----")
	self:set_status(init_status or false ) 
end 
function Filter:_subinit(data)
end 
function Filter:filter(text) 
	return  self._filter_func(text)
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
	rawset(self,"_status", (status and  true) or false )
	self:_set_filter( )
	return self:status() 
end 
-- private 
function Filter:_set_filter()
	local func -- = function(str) return str,str end 
		         
	print( "------- in set_filter() -----" )
	if self:status() then 

		 func= self.__filter_on-- redirection  func  point 
		 print("---- set_filter() , status== true  __filter_on ", func )


		 --[[
		 
         --func= function(str) return str,str end  -- reset  _filter_func when cheng status 
		 
		 --]]
	else 
		 
		 func= self.bypass
		 print("----- status false  set func= bypass",fnuc)

	end 
	rawset(self, "_filter_func", func )  -- _reset_filter()  return new func to _filter 
	

end 

--class = class or {Object=Object}
--class.Filter=Filter

--return Filter

