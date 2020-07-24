#! /usr/bin/env lua
--
-- func_tables.lua
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

local  func_table={
   pinyin= function(str) return "(".. str.. ")" end ,
   terra_pinyan= terra_pinyin ,


}

return func_table

