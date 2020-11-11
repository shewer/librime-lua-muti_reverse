#! /usr/bin/env lua
--
-- format.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

local function terra_pinyin_func(inp)
	if inp == "" then return "","" end
	inp = string.gsub(inp, "([aeiou])(ng?)([1234])", "%1%3%2")
	inp = string.gsub(inp, "([aeiou])(r)([1234])", "%1%3%2")
	inp = string.gsub(inp, "([aeo])([iuo])([1234])", "%1%3%2")
	inp = string.gsub(inp, "a1", "ā")
	inp = string.gsub(inp, "a2", "á")
	inp = string.gsub(inp, "a3", "ǎ")
	inp = string.gsub(inp, "a4", "à")
	inp = string.gsub(inp, "e1", "ē")
	inp = string.gsub(inp, "e2", "é")
	inp = string.gsub(inp, "e3", "ě")
	inp = string.gsub(inp, "e4", "è")
	inp = string.gsub(inp, "o1", "ō")
	inp = string.gsub(inp, "o2", "ó")
	inp = string.gsub(inp, "o3", "ǒ")
	inp = string.gsub(inp, "o4", "ò")
	inp = string.gsub(inp, "i1", "ī")
	inp = string.gsub(inp, "i2", "í")
	inp = string.gsub(inp, "i3", "ǐ")
	inp = string.gsub(inp, "i4", "ì")
	inp = string.gsub(inp, "u1", "ū")
	inp = string.gsub(inp, "u2", "ú")
	inp = string.gsub(inp, "u3", "ǔ")
	inp = string.gsub(inp, "u4", "ù")
	inp = string.gsub(inp, "v1", "ǖ")
	inp = string.gsub(inp, "v2", "ǘ")
	inp = string.gsub(inp, "v3", "ǚ")
	inp = string.gsub(inp, "v4", "ǜ")
	inp = string.gsub(inp, "([nljqxy])v", "%1ü")
	inp = string.gsub(inp, "eh[0-5]?", "ê")
	inp = string.gsub(inp, "([a-z]+)[0-5]", "%1")
	return inp,str
end



--  pattern 字串前置處理
local function exchange_char(str)
	--return str:gsub("$(%d)","%%%1")
	return str:gsub("[$\\]([0-9acdlpsuwxz])","%%%1"):gsub("[$\\]U","%%u"),str 
end 



-- string -->  array   : abcd - > {"a","b","c","d" }
-- for xlit  patten 
local function split(str)
	local ar ={}
	if str then
		for i , v in utf8.codes(str) do 
			table.insert(ar,utf8.char(v))
		end
	end 
	return ar 
end 





local function make_xlit(str)
	print(str)
	local s1
	local s2
	--local str_pattern =exchange_char(str)
	local str_pattern  
	s1,str_pattern,s2= str:match("%s*xlit(.)(.*)([^%s])%s*")  -- return   |   oeuoeuaoeu|oeuoeuaoeuaoeu  |

	if  (s1 ~= s2 ) then
		return nil,true, string.format("(pattern error):splite char not match %s | %s,xlit: %s / %s " ,str,str_pattern ,s1,s2 )
	end

	s1,s2=str_pattern:match(  "(.*)" .. s1  .. "(.*)" )
	if (utf8.len(s1) ~= utf8.len(s2)) then 
		return nil,true, string.format("(pattern error) string lenght form <> to : %s | %s,xlit: %s / %s " ,str,str_pattern ,s1,s2 )
	end 

	--  製作   xlit_tab  轉碼用途 提供 xlit_pattern 查碼轉換  
	local  xlit_tab={}
	local formar=split(s1)
	local toar= split(s2)
	for i=1 , #formar do
		xlit_tab[formar[i]] = toar[i]
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

local function make_xform(str)
	local str_pattern =exchange_char(str)
	local s1
	local s2 

	s1,s2 = str_pattern:match("%s*xform/(.*)/(.*)/%s*")
	if (type(s1) ~="string"  or type(s2) ~= "string")  then 
		return nil,true, string.format("(pattern error): %s | %s,xform: %s / %s " ,str,str_pattern ,s1,s2 )
	end 
	local function xform_pattern(str)
		return str:gsub(s1,s2),str 
	end 
	return xform_pattern, false, nil 
end 

local function make_derive(str)
	local str_pattern =exchange_char(str)
	local s1
	local s2 

	s1,s2 = str_pattern:match("%s*derive/(.*)/(.*)/%s*")
	print(s1,s2)
	if (type(s1) ~="string"  or type(s2) ~= "string")  then 
		return nil,true, string.format("(pattern error): %s | %s, deriver: %s / %s " ,str,str_pattern ,s1,s2 )
	end 
	print(s1 , s1 .." " .. s2)
	local function derive_pattern(str)
		return str:gsub(s1,s1 .. " " .. s2),str
	end 
	return derive_pattern,false, nil
end 

local function make_erase(str)
	local str_pattern =exchange_char(str)
	local s1
	local s2 

	s1,s2 = str_pattern:match("%s*erase/(.*)/%s*")
	print(s1,s2)
	if (type(s1) ~="string"  )  then 
		return nil,true, string.format("(pattern error): %s | %s, erase: %s" ,str,str_pattern ,s1 )
	end 


	local function erase_pattern(str)
		return str:gsub(s1,""),str
	end 
	return erase_pattern,false , nil
end 

local func_tab={
	terra_pinyin = terra_pinyin_func ,
}
local function make_func(str)
	local str_pattern= exchange_char(str )
	local s1
	local s2

	s1,s2= str_pattern:match("%s*func/(.*)/%s*")
	if (type(func_tab[s1]) ~= "function" ) then 

		return nil ,true, string.format("(function not fount): pattern:%s | %s ,function: %s ",str,str_pattern , s1) 
	end 
	return func_tab[s1],false,nil 
end 
-- 1  : "xlit|abcdoeuoeuoaeu|金本口于口紅于電棍|"
local function make_pattern(str)  -- return func , error message   
	if str:match("%s*xlit") then  -- ok
		return  make_xlit( str )  
	elseif str:match("%s*xform") then   -- ok
		return make_xform(str)
	elseif str:match("%s*erase") then
		return make_erase(str)
	elseif str:match("%s*derive") then 
		return make_derive(str)
    elseif str:match("%s*func") then 
		return make_func(str)
	else
		return nil ,true, string.format("(not match /xlit/xform/erase/derive/func/ ): pattern:%s ",str) 
	end 
end 

-- for debug method pattern 
local make_pattern_func_tab={func=make_func,erase=make_erase,xlit=make_xlit,derive=make_derive,xform=make_xform}
local function make_patterns(...)
	pattern_strs={...}
	local f,err,errmsg
	local patterntab_ar ={} -- array of patterntab { pattern: string func: function }
	-- init tab  
	for i ,pattern_str  in ipairs(pattern_strs) do
		func_link,err,errmsg= make_pattern( pattern_str )
		if err then 
			print( "(make_patterns) --" .. errmsg )
		end 
		table.insert(patterntab_ar  ,{pattern=pattern_str, func=func_link } )
	end 
	--  return  patterns func 
	--  patterns(str)
	--     return repese_str , org_str
	local function patterns_func(str)
		-- handle  tab 
		local out_str= str 
		local in_str = str 
		for i,pattern_tab in ipairs(patterntab_ar ) do
			if type( pattern_tab.func) == "function" then 
				out_str,in_str = pattern_tab.func( out_str )
			end 
		end 
		return out_str,str
	end 
	if DEBUG then -- return  patterns function , table of func of make_.... , 
		return patterns_func ,make_pattern_func_tab 
	else 
		return patterns_func 
	end 
end 

------ return  pattern func  
--  function (str)   return  string   
--  "xlit|abc|金木水|"    "aaa" --> 金金金
return make_patterns    
