#! /usr/bin/env lua
--
-- completion.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--

require 'tools/object'

local Completion= Class("Completion")
function Completion:_initialize(translation,init_status)
	self._trans=translation
	--self._status= init_status or false 
	self:set_status(init_status) 

	return true 
end 
function Completion:set_status(flag)
	self._status = flag and true  or false 
	return self._status 
end 
function Completion:status(flag)
	if flag == nil then  return self._status end 
	self._status = flag and true  or false 
	return self._status 
end 

function Completion:iter() 
	return coroutine.wrap( function()

		if self:status() then 
			for cand in self._trans:iter() do 
					if self:check(cand)  then   coroutine.yield(cand) end 
			end 
		else 
			for cand in self._trans:iter() do 
				coroutine.yield(cand)
			end 
		end 
	end )
end 
function Completion:check(cand) 
	return cand.type ~= "completion"    -- true yield cand
end 

return Completion 

