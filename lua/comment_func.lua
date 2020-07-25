#! /usr/bin/env lua
--
-- func_tables.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

local user_table= {}

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
user_table["terra_pinyin"]={
	dbname= "terra_pinyin",
	reverse_func=terra_pinyin_func

}
user_table["bopomofo"]={ 
	dbname= "terra_pinyin", 
	pattern= {
		"xform/^r5$/er5/",
		"xform/^([jqx])y?u/$1v/",
		"xform/^y/i/",
		"xform/^w/u/",
		"xform/iu/iou/",
		"xform/ui/uei/",
		"xform/ong/ung/",
		"xform/([iu])n/$1en/",
		"xform/zh/Z/",
		"xform/ch/C/",
		"xform/sh/S/",
		"xform/ai/A/",
		"xform/ei/I/",
		"xform/ao/O/",
		"xform/ou/U/",
		"xform/ang/K/",
		"xform/eng/G/",
		"xform/an/M/",
		"xform/en/N/",
		"xform/er/R/",
		"xform/eh/E/",
		"xform/([iv])e/$1E/",
		"xform/1/ˉ/",
		"xlit|bpmfdtnlgkhjqxZCSrzcsiuvaoeEAIOUMNKGR2345|ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄧㄨㄩㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦˊˇˋ˙|",
	 }
 }
user_table["cangjie6"]={ 
	dbname= "cangjie6", 
	pattern= {
		"xform/$/〕=-/",
		"xform/^/〔/",
		"xlit|abcdefghijklmnopqrstuvwxyz |日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片、|",
	 }
 }
local comment_tab=require("comment_tab")

function file_exist(path)
	local fp= io.open(path,"r")
	if fp then 
		fp:close()
		return true
	else 
		return false
	end 
end 

function dbfile_exist(dbname)
	
	local filename= "build/" .. dbname .. ".reverse.bin"
	if file_exist(filename) then   -- 開啟 reverse.bin 
		return filename
	else 
		return nil
	end 

end 


local function get_comment(str, quick_str,file_exist )

	local tmp = user_table[str] or comment_tab[str]
	local tab={}
	tab.dbname= tmp.dbname
	tab.text= quick_str 
	print( "-------------", table.unpack( tmp.pattern) )
	tab.reverse_func= tmp.reverse_func or require("format2")( table.unpack(tmp.pattern) )
	tab.dbfile= dbfile_exist(tab.dbname)

	return tab

end
return get_comment



