#! /usr/bin/env lua
--
-- schema_sim.lua
-- Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
--
-- Distributed under terms of the MIT license.
--


local schema_sim={
	{ 
		dbname="whaleliu", text="Vw",hotkey=nil,
		pattern={
			"xlit|dmatwfyzljxiekbhsocrugqnpv[];,|日月金木水火土竹戈十大中一弓人心手口尸廿山女田糸卜魚左右虫羊|",
			"xform/^(.+)$/(鯨)\1/",
		}
	},
	{ 
		dbname="pinyin_luna" , text="Vp" ,hotkey=nil,
		pattern= {
			"xform/([nl])v/$1ü/",
			"xform/([nl])ue/$1üe/",
			"xform/([jqxy])v/$1u/",
			"xform/^/(拼)/",
		}
	},

	{ 
		dbname="cangjie5liu" , text="Vj" ,hotkey=nil,
		pattern= {
			"xform/(.)(.)(?+)/(\1\3\2)/",
			"xlit|dmatwfyzljxiekbhsocrugqnpv|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符|",
			"xform/^(.+)$/(倉)$1",
		}
	},

}

return schema_sim

