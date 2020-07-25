# librime-lua-script

## 反查字典切換

* 可利用 schema 的轉換格式 xlit xform  derive erase 
* 增加   func/terra_pinyin/  配合 format.lua func_tab={ terra_pinyin= terra_pinyin_func } 
* 例:    comment= require("format")( "func/terra_pinyin" , function(str) return "--" .. str .. "--", "xform/ab/df/" )
* 可預設 期初反查字典 DEFAULT_INDEX
* 可設定反查列表數量  CAND_MAX
* 建議可以把 複雜的 reverse_lookup_reverse 移除 ， 避免複雜度  schema 乾淨許多。
* 新增 簡碼反查開關 ，只顯示最短碼 

## 工具
   * make
   * lua
   * ruby  
   * shell 
   
## 安裝
```
export $Rime=path
或 在 Makefile 設定 Rime 
make update   # cp file to  $Rime 

```
## 產生 comment_tab.lua : 從 $Rime/build/ schema.yaml 調出  comment_format & dictionary，減少建立 revdbs table 錯誤
```
make comment_tab  # 

#查找comment list 
cd lua
lua -l comment_tab -e 'comment_list() ' # ( nir|false  | true)  true 連 comment_format: pattern 也print出來
#--------------------  output ----------
#key: newcjliu_ext_pinyin        dbname: luna_pinyin
#key: newcjliu1_reverse_lookup   dbname: newcjliu
#key: cangjie5liu_ext_reverse_lookup_pinyin      dbname: luna_pinyin
#key: bopomofo_tw_reverse_lookup dbname: terra_pinyin



# 手動測試  revdbs 產出   
# 產生  revdb table:{ dbname=reverse.bin  :text 快鍵 reverse_func: 害碼函式  }

lua -e 'test=require("comment_tab")("bopomofo_tw_reverse_lookup","Vp") 
print("dbname: " .. test.dbname)
print("text: " .. test.text)
print("reverse test :"  .. test.reverse_func("ban4fa3"))'
#-----------------output 
#dbname: terra_pinyin
#text: Vp
#rever test: ㄅㄢㄈㄚˇ





```
### putch custom.yaml
```yaml 
custom.yaml 
patch:  
    engine/processors/@after 0: lua_processor@reverse_switch
    engine/filters/@after 1: lua_filter@reverse_lookup_filter

```




###  comment_init.lua   改由 comment_init  設定 以便於管理及除錯 ，也可以在 外部用lua 測試  comment_init 返回資料
      return  { n_key= string ,p_key=string ,revdbs = table , reverse_off= string , quick_code_key = stering} 
      設定範例 見 comment_init.lua 。 
      comment_init.lua  
      comment_func.lua  手動設定 參數  
      comment_tab.lua   從 build/  schema.yaml 調出 
      
       
       
       
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
    require("comment_tab")("bopomofo_tw_reverse_lookup","VP")     --    這樣 也可以 調出 一個反查表
    {dbname= "luna_pinyin",     text="Va" , reverse_func= function(text) return "("..text..")",text end } #  
    
}
 
 ("Control+9", "Control+8",revdbss ,"V-","Control+0")
     --"whaleliu.extended", "luna_pinyin" , "cangjie5liu","newcjliu", "cangjie6liu")
     

--------------------------------------
-- rime.lua 
     
-- nexthot key,prevhot key, revdbs , 關閉反查字串, 簡碼開關   # 新增 簡碼開關 (應該對 table_translator 有用)
-- return { reverse = { init= init_func , func = filter_func} , processor= processor_func }
local rever_lookup_tab= require("reverse_switch")()



-- 設定最大反查數量
CAND_MAX= 99  --  負值: 不設限
DEFAULT_INDEX=1  -- 預設 期初反查表
reverse_lookup_filter = rever_lookup_tab.reverse
reverse_switch = rever_lookup_tab.processor
```


## 以範例說明 操作

總共設定 六個 反查字典 
ctrl-0 ctrl-9 ctrl-8  簡碼開關  正反切換  Vc Vw Vn Vp Vt Vj- 快速切換(請自行設定)

### 格式測試    不小心得一個小工具  不用重新佈署 (但是不保證正確 )
  comment_tab.lua  comment_func.lua  format.lua 可以在 lua5.3 下測試 字串轉換 
  

```
import  package.path  rime/lua/?.lua   或 進入 lua 路逕 

$lua

comment , err, msg = requir("format")( "xlit|abcdefg|tuvwxyz|", "xform/yz/YZ/" , "erase/Z/" ,"xform/(.*)/($1)-test/")
comment("abcdfg")  # return  (tuvwY)-test    abcdfg  (替換  ,   原始)
rep = comment("abcdfg")     # rep=  (tuvwY)-test
rep,org=  comment("abcdfg") # rep=  (tuvwY)-test   org= adcdfg

t=requrie("bopomofo_tw_reverse_lookup","quick_key" )
print(t.dbname , t.text) -- terra_pinyin   quick_key
print( t.reverse_func( "ban4fa3") )      -- ㄅㄢㄈㄚˇ


```
### comment.rb schema_file  ,截取 comment_format 

