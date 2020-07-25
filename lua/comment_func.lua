#! /usr/bin/env lua
--
-- func_tables.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

local table= {}

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
local terra_pinyin2={ 
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

cangjie6={ 
	dbname= "cangjie6", 
	pattern= {
		"xform/$/〕=-/",
		"xform/^/〔/",
		"xlit|abcdefghijklmnopqrstuvwxyz |日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片、|",
	 }
 }
table["terra_pinyin1"]={
	dbnmae= "terra_pinyin",
	text=nil ,
	reverse_func= terra_pinyin
}
table["terra_pinyin2"]= {
	dbname= terra_pinyin2,
	text=nil,
	reverse_func= require("format2")( table.unpack(terra_pinyin2.pattern ) )
}
table["cangjie6"]= {
	dbname=cangjie6.dbname,
	text=nil,
	reverse_func= require("format2")( table.unpack(cangjie6.pattern ) ) 
}

local function get_comment(str, quick_str)
	local tad={}
	local tmp
	if table[str] then 
		t= table[str]
	else 
		--t=require("comment_tab")(str,quick_str)
	end 
	tab.dbname= t.dbname
	tab.text= quick_str
	tab.reverse_func=t.reverse_func
	return tab

end
return get_comment



