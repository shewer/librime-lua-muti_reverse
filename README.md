# librime-lua-script

## 反查字典切換

* 可利用 schema 的轉換格式 xlit xform  derive erase 
* 增加   func/terra_pinyin/  配合 format.lua func_tab={ terra_pinyin= terra_pinyin_func } 
* 例:    comment= require("format")( "func/terra_pinyin" , function(str) return "--" .. str .. "--", "xform/ab/df/" )
* 可預設 期初反查字典 DEFAULT_INDEX
* 可設定反查列表數量  CAND_MAX


## 安裝
```bash
cp ./lua/reverse_switch.lua  rime user path  Rime/lua
cp ./lua/format.lua 

```

### putch custom.yaml
```yaml 
custom.yaml 
patch:  
    engine/processors/@after 0: lua_processor@reverse_switch
    engine/filters/@after 1: lua_filter@reverse_lookup_filter

```




### setup rime.lua
```lua
-- 設定 comment 字串 
-- [[ " " ]]  是lua 的字串跳脫格式 如果有問題 可以加上 試試 
 comment_whileliu=require("format")(
     "xlit|dmatwfyzljxiekbhsocrugqnpv|日月金木水火土竹戈十大中一弓人心手口尸廿山女田糸卜魚|",
     [[ "xform/(.*)/($1)鯨/" ]]
     )
 comment_luna_pinyin= function (str) return str end
 comment_newcjliu=require("format")(
      "xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
      [[ "xform/(.*)/($1)新/" ]]  
 )
 comment_cangjie5liu=require("format")(
      "xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
      [[ "xform/(.*)/($1)倉/" ]]
 )
 comment_cangjie6liu=require("format")(
      "xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
      [[ "xform/(.*)/($1)蒼/" ]]
 )
 comment_terra_pinyin=require("format")(
    "func/terra_pinyin/",
  [[ "xform/(.*)/($1)拼/" ]]

 )
 
 --  建立反查字典參數
revdbss={ -- 反查字典名  ， 快速切換輸入字串 , 反查函式
    {dbname="whaleliu.extended",text="Vw",  reverse_func=comment_whileliu },
    {dbname="luna_pinyin",      text="Vp",  reverse_func=comment_luna_pinyin },
    {dbname="terra_pinyin",     text="Vt",  reverse_func=comment_terra_pinyin},
    {dbname="newcjliu",         text="Vn",  reverse_func=comment_newcjliu },
    {dbname="cangjie5liu",      text="Vc",  reverse_func=comment_cangjie5liu },
    {dbname="cangjie6liu",      text="Vj",  reverse_func=comment_cangjie6liu },    --  {db= "terre_pinyin" }    表  沒有快碼

}
 
-- nexthot key,prevhot key, revdbs , 關閉反查字串
-- return { reverse = { init= init_func , func = filter_func} , processor= processor_func }
local rever_lookup_tab= require("reverse_switch")("Control+0", "Control+9",revdbss ,"V-")
     --"whaleliu.extended", "luna_pinyin" , "cangjie5liu","newcjliu", "cangjie6liu")

-- 設定最大反查數量
CAND_MAX= 99
DEFAULT_INDEX=1
reverse_lookup_filter = rever_lookup_tab.reverse
reverse_switch = rever_lookup_tab.processor
```


## 以範例說明 操作

總共設定 六個 反查字典 
ctrl-0 ctrl-9  正反切換  Vc Vw Vn Vp Vt Vj- 快速切換

### 格式測試
import  package.path  rime/lua/?.lua   或 進入 lua 路逕 

$lua

comment , err, msg = requir("format")( "xlit|abcdefg|tuvwxyz|", "xform/yz/YZ/" , "erase/Z/" ,"xform/(.*)/($1)-test/")
comment("abcdfg")  # return  (tuvwY)-test    abcdfg  (替換  ,   原始)
rep = comment("abcdfg")     # rep=  (tuvwY)-test
rep,org=  comment("abcdfg") # rep=  (tuvwY)-test   org= adcdfg




