





--[[  patch  custom.yaml  
--  ctrl-7 8 9 0    reverse off /prev /next   / short-code
--  V1 V2 V3 V4 VV Vd  /
--
    engine/processors/@after 0: lua_processor@reverse_switch
    engine/filters/@after 1: lua_filter@reverse_lookup_filter

	-- debug mode 
    engine/translators/@next:  lua_translator@debug # lua_translator@date_translator
    #engine/translators/@next:  lua_translator@date_translator
    recognizer/patterns/debug: "^[GLF].*$"
--]] 





local rever_lookup_tab= require("reverse_switch")()
	 
-- 設定最大反查數量 負值 不設定
CAND_MAX= -1
DEFAULT_INDEX=1
reverse_lookup_filter = rever_lookup_tab.reverse
reverse_switch = rever_lookup_tab.processor
translator_debug= rever_lookup_tab.translator
