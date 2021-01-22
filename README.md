# librime-lua-script

## 反查字典切換

* 可利用 schema 的轉換格式 xlit xform  derive erase 
* 巳可由主副字典 自載反查    或 ~~自設~~
* 三步安裝/移除    加一行 __include: reverse_switch:/patch 且不污染 schema.yaml 不喜歡 remark rime.lua  custom.yaml 兩行 
* 

* ~~可預設 期初反查字典 DEFAULT_INDEX~~
* ~~可設定反查列表數量  CAND_MAX~~
* 建議可以把 複雜的 reverse_lookup_reverse 移除 ， 避免複雜度  schema 乾淨許多。
*
* 新增 簡碼反查開關 ，只顯示最短碼 
* ~~設定參數 移至 reverse_init.lua  簡化 rime.lua  & reverse_switch.lua  且 reverse_init.lua( bypass ReverseDb) 可獨立測試 調整~~
*
* 改版 : 改架構  使用 filter  模式 設計 
* ~~範例 有4個 內含 反查表   cangjie5 cangjie6 lerra_pinyin  luna_pinyin   (見 reverse_init.lua )~~
* 熱鍵設定 在 userdir/lua/muti_reverse/init.lua 檔頭 
* Ctrl+6 關閉 反查
* ctrl+7 反查只顯示 最短碼
* ctrl+8  關閉 未完成碼上屏開關( 在 not compsing 狀態下切換 )
* Ctrl+9 next  
* Ctrl+0 prev 
* Ctrl+F11  candinfo(type,start , end ,quality , text,preedit , comment )加入comment
* ~~Vd  on/off : debug-info mode show cand type start end quility in comment ~~
* ~~V1 V2 V3 V4 快速切換  ~~



## 工具
   * ~~make~~
   * lua
   * ~~ruby~~
   * ~~shell~~
   
## 安裝 三步安裝    --  安裝移除 都 不影嚮 schema  
```
1. git clone https://github.com/shewer/librime-lua-tools  $USERDATA/lua/tools 
2. git clone https://github.com/shewer/librime-lua-muti_reverse $USERDATA/lua/muti_reverse
3. 在方案.custom.yaml 加入   ( cp reverse_switch.yaml $USERDATA )
     patch:
	    __include: reverse_switch:/patch   # reverse_switch.yaml

4. 在 rime.lua加入 ( rime.lua) 
     load_module=require('tools/loadmodule')  
     load_module.load("muti_reverse","muti_reverse","preedit_format") 
	 --   參數1 require 'muti_reverse/init.lua' 
	 --   參數2 tag name  ( lua_processor@muti_reverse_processor  ....)
	 --   參數3 此模組 反查輸出格式， 引用 字典 prreedit_format )
     
     
手動建立 全域變數     
local tab=require("muti_reverse")(**"preedit_format"**) 
muti_reverse_processor=tab.procssor  --   lua_processor@muti_reverse_processor
muti_reverse_filter=tab.filter       --   lua_filter@muti_reverse_fiter



-- 自動建立 相關 lua 套件 以"muti_reverse" + 套件名  reverse_switch.yaml  lua @tags 名要相同，第二個參數
是 設定 使用 preedit_fmt / comment_fmt pattern 置換  cand.comment 字串 
建議 完善 translators的comment_format  並使用 "comment_fmt"
-------
以此例  
lua 會建立 全域 tab 
```lua
return {
        processor= { func=processor_func, init=processor_init_func, fini=processor_fini_func} ,
        filter=    { func=filter_func, init=filter_init_func,    fini=filter_fini_func } ,

}

muti_reverse_processor= processor  -- lua_processor@muti_reverse_processor
muti_reverse_filter= filter         -- lua_filter@muti_reverse_filter

```

```yaml
### reverse_switch.yaml 

patch:  
    engine/processors/@after 0: lua_processor@muti_reverse_processor
    engine/filters/@after 1: lua_filter@muti_reverse_filter

```





       
       

 




