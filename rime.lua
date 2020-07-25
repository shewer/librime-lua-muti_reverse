--[[
librime-lua 样例

调用方法：
在配方文件中作如下修改：
```
  engine:
    ...
    translators:
      ...
      - lua_translator@lua_function3
      - lua_translator@lua_function4
      ...
    filters:
      ...
      - lua_filter@lua_function1
      - lua_filter@lua_function2
      ...
```

其中各 `lua_function` 为在本文件所定义变量名。
--]]

--[[
本文件的后面是若干个例子，按照由简单到复杂的顺序示例了 librime-lua 的用法。
每个例子都被组织在 `lua` 目录下的单独文件中，打开对应文件可看到实现和注解。

各例可使用 `require` 引入。
如：
```
  foo = require("bar")
```
可认为是载入 `lua/bar.lua` 中的例子，并起名为 `foo`。
配方文件中的引用方法为：`...@foo`。

--]]


-- I. translators:

-- date_translator: 将 `date` 翻译为当前日期
-- 详见 `lua/date.lua`:
date_translator = require("date")

-- time_translator: 将 `time` 翻译为当前时间
-- 详见 `lua/time.lua`
--time_translator = require("time")

-- number_translator: 将 `/` + 阿拉伯数字 翻译为大小写汉字
-- 详见 `lua/number.lua`
--number_translator = require("number")


-- II. filters:

-- charset_filter: 滤除含 CJK 扩展汉字的候选项
-- charset_comment_filter: 为候选项加上其所属字符集的注释
-- 详见 `lua/charset.lua`
--local charset = require("charset")
--charset_filter = charset.filter
--charset_comment_filter = charset.comment_filter

-- single_char_filter: 候选项重排序，使单字优先
-- 详见 `lua/single_char.lua`
--single_char_filter = require("single_char")



-- comment format setting 
-- lua regular  不是符合 POSIX 太複雜 可能會錯誤 ，但是會 bypass 錯誤的pattern 
-- 或者 直接修改 lua format 
-- 可以用lua console  測試  
--[[

記得加上 library path
ex  pwd 在rime 下 


package.path = package.path .. ";./lua/?.lua"
執行 
下列 comment
ex:
pattern,err,errmess= require("format")("xlit|abcd|wxyz|" , "xform/w/W4/","erase/z/","xform/(.*)/-($1)-/")

OK: function , false , nil
NG: nil      ,  true , "error msg " 





--]] 

local rever_lookup_tab= require("reverse_switch")()
	 
-- 設定最大反查數量 負值 不設定
CAND_MAX= -1
DEFAULT_INDEX=1
reverse_lookup_filter = rever_lookup_tab.reverse
reverse_switch = rever_lookup_tab.processor
--  設定 rime.lua  將兩項 加入 custom.yaml  
    --#engine/processors/@after 0: lua_processor@revrse_switch  
    --#engine/filters/@after 1: lua_filter@reverse_lookup_filter
					
--executor = require("executor")

--- 百度云拼音，Control+t 为云输入触发键
--- 使用方法：
--- 将 "lua_translator@baidu_translator" 和 "lua_processor@baidu_processor"
--- 分别加到输入方案的 engine/translators 和 engine/processors 中
--local baidu = require("trigger")("Control+t", require("baidu"))
--baidu_translator = baidu.translator
--baidu_processor = baidu.processor
