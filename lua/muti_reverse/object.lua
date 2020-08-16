#! /usr/bin/env lua
--
-- object.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

require 'muti_reverse.metatable'
--- for Object base replace tostring  
local function objtostring(obj)
	return string.format("%s %s",obj._cname,obj._addr)
end 


--function Dbs:conver(word)
	--local  text=self._dbs[self._index]:conver(word )
	--local qstr = ( self._quick_code_flag and self.quick_code(text ) )	or text 
	--return self._dbs[index]:conver(qstr) ,text,word  
--end 
function __FILE__() return debug.getinfo(2, 'S').source end
function __LINE__() return debug.getinfo(2, 'l').currentline end
function __FUNC__() return debug.getinfo(2, 'flnSu').name end

function class(classname,extend)
	local t ={ _cname=classname} 
	local mt= { __index=extend,__name=classname}

	return setmetatable(t,mt)
end 
Object=class("Object",table)
--Object={ _cname="Object",__index=table,} 
--Object._addr=  string.match(tostring(Object),".*%s+(%w+)")
--Object_mt= { __index= table, __tostring=objtostring }
--setmetatable( Object ,{__index=table } )
function Object:__mt(mt)
	   return (mt and setmetatable(self,mt) ) or getmetatable(self)
end
function Object:is_a(class)
	local _class = self:class()
	

	if  _class ~= class and _class == Object then  
		return false 
	else 
		return  _class == class or _class:is_a(class)  
	end 

end 


	

function Object:super( ...) -- remove  argv methods 
    print ("=====object====super============")
	local method= debug.getinfo(2, 'flnSu').name --  return  method by who called super _ 
    local name=__FUNC__()
    local class=getmetatable(self).__index
    local superclass=getmetatable(class).__index
    print( string.format("---------basicObject:super methodname:  %s --%s -- %s  class: %s, superclass %s",
			method,name, method,class,superclass ) )
    superclass[method](self, ...)

end
--function Object:_tostring()
	----return string.format("%s" ,self)
	----return tostring(self)
	----return self._cname
	--return self._cname .. "  " .. self._addr
--end 

function Object:new( ...)
	local o={}
	o._table=tostring(o)
	o._addr=  string.match(tostring(Object),".*%s+(%w+)")
	local mt= self:__mt()
	local cname= "(@".. mt.__name  .. ")"  --- error  mt.__name nil 
	local _mt= { __index=self , __name=cname }
	--_mt.__tostring= function(tab)
		--return  (tab.tostring and tab.tostring())  or string.format( "(@ -%s, : %s -", tab._cname, tab._addr)
	--end 
	o=setmetatable(o,_mt) 
	o:_initialize(...)
	print("----- new after init -------")
	--getmetatable(o).__newindex= function(t,k,v ) print(t,k,v ,"Warring: can't create valeu after initialize") end  
	return o
end 
function Object:class()
	return getmetatable(self).__index  
end 

function Object:_initialize(...)

end 



package.loaded.class={}
package.loaded.class["Object"]=Object

local class={ 
	Object =Object,

}

--local Enumerable= setmetatable({_cname="Enumerable"}, { __index=Object} )
--local Array=setmetatable( {_cname="Array"} , {__})
return class
