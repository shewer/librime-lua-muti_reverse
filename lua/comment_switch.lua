#! /usr/bin/env lua
--
-- comment_swtch.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
require 'metatable'
local function objtostring(obj)
	return string.format("%s %s",obj._cname,obj._addr)
end 

local function quick_code(text)
	local str=""
	local tab=metatable( text:split())
	tab:sort( 
	function(v1,v2) 
		return #v1 < #v2 
	end )
	local len_min=100
	for i,elm in ipairs(tab) do 
		len_min=  ( ( len_min <=  #elm ) and len_min  ) or #elm
		if #elm <= len_min then 
			return str .." ".. elm
		else 
			break 
		end 
	end
	return str,text 
end 

--function Dbs:conver(word)
	--local  text=self._dbs[self._index]:conver(word )
	--local qstr = ( self._quick_code_flag and self.quick_code(text ) )	or text 
	--return self._dbs[index]:conver(qstr) ,text,word  
--end 
local Object={ _cname="Object",__index=table,} 
Object._addr=  string.match(tostring(Object),".*%s+(%w+)")
local Object_mt= { __index= table, __tostring=objtostring }
setmetatable( Object ,{__index=table } )
local Array={ _cname="Array", __index=Object}
setmetatable( Array,Array )



function Object:new( ...)
	local o={}
	o._table=tostring(o)
	o=setmetatable(o,{__index=self}) 
	o:_initialize(...)
	print("----- new after init -------")
	getmetatable(o).__newindex= function(t,k,v ) print(t,k,v ,"Warring: can't create valeu after initialize") end  
	return o
end 
function Object:class()
	return getmetatable(self).__index  
end 

function Object:_initialize(...)

end 

local Enumerable= setmetatable({_cname="Enumerable"}, { __index=Object} )
local Array=setmetatable( {_cname="Array"} , {__})
Filter= setmetatable( {_cname="Filter"},{ __index=Object})

function Filter.bypass(str)
	return str,str
end 

function Filter:_initialize(filter_func,init_switch) 
	self._switch=init_switch or false
	self._filter= filter_func or Filter.bypass
	print("------- init finisth ------")
end 
function Filter:status()
	return self._switch
end 
function Filter:filter(text) 
	return  (self:status()  and self._filter(text) ) or self.bypass(text)
end 
function Filter:toggle()
	self._switch= not self._switch
	return self._switch
end 
function Filter:on()
	self._switch= true 

	return self._switch
end 
function Filter:off()
	self._switch= false
	return self._switch
end 
function Filter:set_switch(status)
	self._switch= (status and true) or false
	return self._switch
end 
local DBFilter = setmetatable( {_cname="DBFilter"},{ __index=Filter })
function DBFilter:initialize(dbname,dbfile)
	if dbname then
	    self._dbname=dbname 
		self._dbfile = dbtab.dbfile or "build/" .. dbtab.dbname .. ".reverse.bin"
		self._db= false
		self._filter= filter_func or Filter.bypass

	end 

end 
function DBFilter:open()
	self._db=ReverseDB(self._dbfile)
	self._filter= function(text)

		if self._db then 
			return self._db:lookup(text),text   or self.bypass(text)
		else 
			return self.bypass(text)
		end 

	end 
end 
function DBFilter:switch()
	return self._db and self._switch
end 

Dbs=setmetatable( {_cname="Dbs" },{__index=Object } ) 
function Dbs:_initialize(dbs)
	self._index=init_index or 0
	self._base=1
	self._quick_code_flag=false
	self._dbs=metatable() 
	self._dbs:each (function(db) self:insert(db) end ) 
	self.filters= metatable()


end 
function Dbs:insert( db )
	self._dbs:insert(db)
	self._base = self._base + 1
	return self._base
end 
function Dbs:cmdlist()
	return self._dbs:map(function(v,i) return v._text end )
end 
function Dbs:filter(text)
	if self._index==0 then 
		return text,text
	end 
	return self._dbs[self._index]:filter_list():reduce(
	    function(elm,org) 
			return elm:filter(org)     
		end,text   )
end 
function Dbs:next()
	self._index =(self._index+1 +self._base) % self._base
	return self._index
end 
function Dbs:prev()
	self._index =(self._index-1 +self._base) % self._base
	return self._index
end 
function Dbs:set_index(n)
	self._index=  ( n + self._base ) % self._base
	return self._index
end 
function Dbs:reset()
	self._index= 0
	return self._index
end 
function Dbs:quick_code_toggle()
	return self._dbs[self._index]:quick_code_toggle() 
end 
function Dbs:inspect()
	return self._index, self._dbs[ self._index ] 
end 



local Switch=setmetatable( {_cname="Switch"},{__index=Object } )
function Switch:_initialize(dbs, nkey,pkey,rkey,qkey)
	self._texts={}
	self._dbs= self:init_dbs(dbs)
    self:n_key(nkey)
	self:p_key(pkey)
	self:reset_key(rkey)
	self:quick_code_key(qkey)


end

function Switch:init_dbs(dbs)
	metatable( dbs:cmdlist():each (function(v,i) self:insert_text(v,i)  end  ) ) 
	return dbs
end 
function Switch:n_key(key)
	self._texts[key]=function() return  self._dbs:next() end   
	return key
end 
function Switch:p_key(key)
	self._texts[key]=function() return self._dbs:prev() end 
	return key
end 
function Switch:reset_key(key) 
	self._texts[key]=function() return self._dbs:reset() end 
	return key
end 
function Switch:quick_code_key(key) 
	self._texts[key]=function() return self._dbs:quick_code_toggle() end 
	--self._texts[key]=function() return self._dbs:quick_code_toggle() end 

	return key
end 
function Switch:insert_text(key,index)
	self._texts[key]=function() return self._dbs:set_index(index ) end 
	return key,index 
end 
function Switch:check(key)
	return  (self._texts[key] and self._texts[key]() )  or false 
end  


local Reverse= setmetatable({_cname="Reverse",_qcode=Filter:new(quick_code), },{__index=Object })
function Reverse:quick_code_toggle()
	return self._qcode:toggle()
end 
function Reverse:_initialize(dbtab)
	--self:class()._dbs 
	self:set_revdb(dbtab) 
end 

function Reverse:set_revdb(dbtab)
	if dbtab.dbname then 
		self._dbfile = dbtab.dbfile or "build/" .. dbtab.dbname .. ".reverse.bin"
		self._pattern= dbtab.pattern or { "xform/^(.*)$/$1-" }
		self._text=dbtab.text
		local func= dbtab.reverse_func  or  require("format2")()( table.unpack(self._pattern ) )
		print("reverse : set_revdb ",func)
		self._reverse_filter= Filter:new(func,true)  
		self._reverdb_filter= Filter:new()
	end
end 
function Reverse:opendb()
	self._db= ReverseDb(tostring(self._dbfile   or "")) 
	return self._db
end 
function Reverse:reverse_filter()
	return self._reverse_filter
end 

function Reverse:filter_list()
	return metatable{ self._reverdb_filter, self._qcode, self._reverse_filter } 
end 
function Reverse:filter(word)
	return   self:conver(word)  
end 

function Reverse:conver(word)
	-- 反查碼 字根轉換函式   reverse_lookup_filter  init(env) 建立 {db: 反查檔 和 xform_func: 轉碼函式} 整合
	-- 限定 filler 數量 : 後面的資料會衼 此filler 取消 
	--  quick_code  on /off 
	local rever_code =  (self._db  and self._db:lookup(word) ) or "----" -- get text

end 



-- 簡碼飾選 
function Reverse.quick_code(codes_str,sep)
	-- init  sep char  and tab 
	local match_str ,tab= sep or "%S+" , {}
	if match_str == "" then
		match_str="."
	end
	-- conver to tab
	for v in string.gmatch(codes_str,match_str) do
		table.insert(tab,v)
	end
	-- bypass word less 2
	if #tab <2 then
		return codes_str
	end 
	-- sort tab    short word first 
	table.sort(tab,  function(a,b) return a:len() < b:len() end )
	-- combine string of  short words 
	local str,str_leng_min= "", tab[1]:len()
	for i,v in ipairs(tab) do
		if v:len() > str_leng_min then 
			break
		end 
		str= str..v.." "
	end 
	return str:match("%s*(.*[^%s])%s+")
end

--- a="aaaaa" 
--  a:filter( funcction(str) str:gsub("a","z") end 
--  )   
function string:filter(func)
	return (func and func(self)) or self,self
end 


package.loaded["Object"]=Object
package.loaded["Dbs"]=Dbs
package.loaded["Filter"]=Filter
package.loaded["DBFilter"]=DBFilter
package.loaded["Switch"]=Switch
package.loaded["Reverse"]=Reverse
return {Object=Object,Dbs=Dbs,Filter=Filter,Switch=Switch,Reverse=Reverse, qcode=quick_code}
