#! /usr/bin/env lua
--
-- init.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--
lualog=log
log=require( 'muti_reverse.log')(log)
require 'muti_reverse.metatable'
require 'muti_reverse.object'
require 'muti_reverse.switch'   -- hotkey & text 檢查 符合

require 'muti_reverse.filter' 
require 'muti_reverse.ffilter'  -- function filter    FFilter:new( func,initstatus)  -- ture|false 
require 'muti_reverse.pfilter'  -- pattern filter     PFilter:new( "xform|ab|xy|",initstatus)
require 'muti_reverse.psfilter' -- patterns filter    PSFilter:new( matetable({"xform|ab|xy|" , xlit|abcd|日月金木|",initstatus)
require 'muti_reverse.dbfilter' -- reverdb filter     DBFilter:new({dbname="cangjie"},initstatus )
require 'muti_reverse.filterlist' -- filters list     FilterList:new( {dbfilter,qcodefilter,reversefilter},initstatus)
require 'muti_reverse.filterlist_switch'

--require 'muti_reverse.dbs'    取消
--require 'muti_reverse.reverse' 取消




