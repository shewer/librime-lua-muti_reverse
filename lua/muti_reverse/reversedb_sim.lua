#! /usr/bin/env lua
--
-- reversedb_sim.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

require 'tools/metatable'
require 'tools/object'

local function changfilename(fname)
	local _dbname=fname:split("[/.]")[2]
	print("----:----",fname,_dbname) 
	return  "./" .. _dbname .. ".dict.yaml"
end 

ReverseDb=Class("ReverseDb")
function ReverseDb:_initialize(filename)
	self._dict= self:opendb( changfilename(filename))
	return true
end
function ReverseDb:lookup(word)
	 local reverse= self._dict[word]  or {}
	 return table.concat(reverse, " ") 
 end 
function ReverseDb:opendb(dict_filename)
	local file= io.open(dict_filename)
	local dict= metatable()
	local flg=false
	for line in file:lines() do 
		local k,v = line:split("\t"):unpack()
		if flag and not line:match("^#") then 
			dict[k] =dict[k] or {} 
			table.insert(dict[k] ,v ) 
		end 
		if line:match("^%.%.%.") then fig=true end 
	end 
	file:close()
	return dict
end 












return ReverseDb

