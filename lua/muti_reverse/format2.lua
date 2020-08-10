#! /usr/bin/env lua
--
-- format2.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
-- 

--require 'metatable'





-- string -->  array   : abcd - > {"a","b","c","d" }
-- for xlit  patten 
local function split(str)
	local ar ={}
	for i , v in utf8.codes(str) do 
		table.insert(ar,utf8.char(v))
	end
	return ar 
end 
local function make_xlit(str1,str2)
	local tab1=str1:split("")
	local tab2=str2:split("")
	--  如果 字串長度不一 return str str 
	if   #tab1 ~= #tab2 then 
		return function(str)  return str,str end 
	end 
	local strar={} 

	tab1:eachi(function(v,i) strar[v] = tab2[i] end  )

	--  xlit 主要轉檔程式 
	local function  xlit_pattern(str)
		return str:split(""):
				map(
			      function(v) 
					  return strar[v] or v 
				  end ):
				concat() ,str   -- reterun newstr , str 

	end 
	return xlit_pattern ,false, nil

end 
local function make_xlit1(str1,str2)
	--  製作   xlit_tab  轉碼用途 提供 xlit_pattern 查碼轉換  
	--  如果 字串長度不一 return str str 
	if  utf8.len(str1) ~= utf8.len(str2) then 
		return function(str)  return str,str end 
	end 
	local  xlit_tab={}
	local formar=split(str1)
	local toar= split(str2)

	for i,form in ipairs(formar)  do
		xlit_tab[form] = toar[i]
	end 

	--  xlit 主要轉檔程式 
	local function  xlit_pattern(str)
		local strar=split(str)
		local ostr=""
		for i,v in ipairs(strar) do 
			ostr = ostr .. ( xlit_tab[v]  or v ) 
		end 
		return ostr , str
	end 
	return xlit_pattern ,false, nil

end
local function token1(pattern_str)

	local function token1s(token_ar)
		local sp=string.format( [[(.*[^%s])%s?]],token_ar[2],token_ar[2])
		local s1=string.match(token_ar[3],sp) or  ""
		local s2=""
		return token_ar[1],s1,s2

	end 

	local function token2s(token_ar)
		local sp=string.format( [[(.*[^%s])%s?]],token_ar[2],token_ar[2])
		sp= sp..token_ar[2]..sp
		local  s1,s2
		s1,s2=string.match(token_ar[3],sp)
		s1= s1 or ""
		s2= s2 or ""
		return token_ar[1],s1,s2

	end
	--  pattern 字串前置處理
	local function exchange_char(str)
		--return str:gsub("$(%d)","%%%1")
		return str:gsub("[$\\]([0-9acdlpsuwxz])","%%%1"):gsub("[$\\]U","%%u"),str 
	end 
	local function pre_token(patter_str)
		local str = exchange_char( pattern_str )
		local sp=string.format( [[(.*[^%s])%s?]]," "," ")
		local token_ar = {str:match( "%s*(%w*)(.)".. sp .. "%s*" ) }
		return (#token_ar == 3 ), token_ar
	end 
	--  word link token func 
	local word_tab= { xlit=token2s,xform=token2s,derive=token1s,erase=token1s,func=token1s}
	local flag,token_ar = pre_token(  pattern_str   )
	if (flag and word_tab[token_ar[1] ]) then  --  flag ( tokensize = 3 ) and token_ar[1] word match  element of word_tab 
		return word_tab[token_ar[1]](  token_ar     )
	else
		return "","",""
	end 
end
local function token(str)
	word,chr,substr= str:gsub("[$\\]([0-9acdlpsuwxz])","%%%1"):gsub("[$\\]U","%%u"):
	match("%s*(%w*)(.)(.*[^%s])%s*")
	--return word,substr:match("(.*)" .. chr .."(.*)")
	return word,substr:split(chr):unpack()
end 
--word,chr,substr=str:match("%s*(%w*)(.)(.*[^%s])%s*")


local function make_pattern_func( pattern_str)
	local word,str1,str2 = token(pattern_str)
	local func
	if word == "xform" then 
		func= function (str)
			return str:gsub(str1,str2) , str
		end 
	elseif word == "earse" then 
		func= function( str)
			return str:gsub(lstr1,lstr2) ,str
		end
	elseif word == "derive" then 
		func= function(str )
			return str.." "..str:gsub(lstr1,lstr2), str
		end
	elseif word == "xlit" then 
		func= make_xlit(str1,str2)
	elseif word == "func" then
		-- 未完成 
		--func= loadstring(func_table[str] .."()")
	end 
	if  func then 
		return func,false,nil
	else 
		return nil ,true, string.format("(not match /xlit/xform/erase/derive/func/ ): pattern:%s ",str) 
	end 


end 
local function make_patterns( ... )
	local pattern_ar=metatable( ... )
	--print("---- debug --- make_patterns:155")
	--pattern_ar:each(print)
	local pattern_ar_func=pattern_ar:map(make_pattern_func  )   -- create new table of func point 
	local function rever(elm,rstr)   -- callback function  of reduce
		return  elm(rstr),rstr
	end 
	return function(str)     -- return function point 
		return pattern_ar_func:reduce(rever, str) ,str 
	end 
end 

local function  make_patterns1( ... )
	pattern_ar={...}
	-- init  pattern funcs 
	--  patter_str_ar   -->  fattern_funcs_ar 
	local pattern_funcs={}
	for i ,pattern_str in ipairs(pattern_ar) do 
		local func=make_pattern_func( pattern_str )  -- return func(str)  ( word,s1,s2 ) 
		table.insert(pattern_funcs,  func)
	end 
	-- return  filter function 
	return function(str)
		local orgstr=str 
		local newstr=str
		for i,filter in ipairs(pattern_funcs) do
			newstr,orgstr= filter(newstr)    -- return new, org 
		end 
		return newstr,str
	end 

end 


return function() 
	return make_patterns, make_pattern_func 
end 
