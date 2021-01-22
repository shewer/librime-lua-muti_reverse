local comment_tab= { }

-- rime_user/build/bopomofo_hsuq.schema.yaml
comment_fmt["bopomofo_hsuq_reverse_lookup"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^r5$/er5/",
		"xform/^([jqx])y?u/$1v/",
		"xform/^y/i/",
		"xform/^w/u/",
		"xform/iu/iou/",
		"xform/ui/uei/",
		"xform/ong/ung/",
		"xform/([iu])n/$1en/",
		"xform/zh/Z/",
		"xform/ch/C/",
		"xform/sh/S/",
		"xform/ai/A/",
		"xform/ei/I/",
		"xform/ao/O/",
		"xform/ou/U/",
		"xform/ang/K/",
		"xform/eng/G/",
		"xform/an/M/",
		"xform/en/N/",
		"xform/er/R/",
		"xform/eh/E/",
		"xform/([iv])e/$1E/",
		"xform/1/ˉ/",
		"xlit|bpmfdtnlgkhjqxZCSrzcsiuvaoeEAIOUMNKGR2345|ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄧㄨㄩㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦˊˇˋ˙|",
	 },
 }
-- rime_user/build/bopomofo.schema.yaml
comment_fmt["bopomofo_reverse_lookup"]={ 
	dbname= "cangjie5" 
	pattern= {
		"xform/e?r5$/er5/",
		"xform/iu/iou/",
		"xform/ui/uei/",
		"xform/ong/ung/",
		"xform/^yi?/i/",
		"xform/^wu?/u/",
		"xform/iu/v/",
		"xform/^([jqx])u/$1v/",
		"xform/([iuv])n/$1en/",
		"xform/zh/Z/",
		"xform/ch/C/",
		"xform/sh/S/",
		"xform/ai/A/",
		"xform/ei/I/",
		"xform/ao/O/",
		"xform/ou/U/",
		"xform/ang/K/",
		"xform/eng/G/",
		"xform/an/M/",
		"xform/en/N/",
		"xform/er/R/",
		"xform/eh/E/",
		"xform/([iv])e/$1E/",
		"xform/1//",
		"xlit|bpmfdtnlgkhjqxZCSrzcsiuvaoeEAIOUMNKGR2345|ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄧㄨㄩㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦˊˇˋ˙|",
	 },
 }
-- rime_user/build/bopomofo_tw.schema.yaml
comment_fmt["bopomofo_tw_reverse_lookup"]={ 
	dbname= "cangjie5" 
	pattern= {
		"xform/e?r5$/er5/",
		"xform/iu/iou/",
		"xform/ui/uei/",
		"xform/ong/ung/",
		"xform/^yi?/i/",
		"xform/^wu?/u/",
		"xform/iu/v/",
		"xform/^([jqx])u/$1v/",
		"xform/([iuv])n/$1en/",
		"xform/zh/Z/",
		"xform/ch/C/",
		"xform/sh/S/",
		"xform/ai/A/",
		"xform/ei/I/",
		"xform/ao/O/",
		"xform/ou/U/",
		"xform/ang/K/",
		"xform/eng/G/",
		"xform/an/M/",
		"xform/en/N/",
		"xform/er/R/",
		"xform/eh/E/",
		"xform/([iv])e/$1E/",
		"xform/1//",
		"xlit|bpmfdtnlgkhjqxZCSrzcsiuvaoeEAIOUMNKGR2345|ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄧㄨㄩㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦˊˇˋ˙|",
	 },
 }
-- rime_user/build/cangjie5liu1.schema.yaml
comment_fmt["cangjie5liu1_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie5liu1_reverse_lookup"]={ 
	dbname= "cangjie5" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|abcdefghijklmnopqrstuvwxyz~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
comment_fmt["cangjie5liu1_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie5liu1_translator"]={ 
	dbname= "cangjie5" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|abcdefghijklmnopqrstuvwxyz~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
comment_fmt["cangjie5liu1_vcode"]={ 
	dbname= "cangjie5" 
	pattern= {
		"xlit|abcdefghijklmnopqrstuvwxyz~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
 }
-- rime_user/build/cangjie5liu_ext.schema.yaml
comment_fmt["cangjie5liu_ext_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie5liu_ext_reverse_lookup"]={ 
	dbname= "cangjie5liu.extended" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
comment_fmt["cangjie5liu_ext_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie5liu_ext_translator"]={ 
	dbname= "cangjie5liu.extended" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
comment_fmt["cangjie5liu_ext_vcode"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
 }
-- rime_user/build/cangjie5liu.schema.yaml
comment_fmt["cangjie5liu_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie5liu_reverse_lookup"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
comment_fmt["cangjie5liu_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie5liu_translator"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
comment_fmt["cangjie5liu_vcode"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
 }
-- rime_user/build/cangjie5.schema.yaml
comment_fmt["cangjie5_reverse_lookup"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xlit|abcdefghijklmnopqrstuvwxyz|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符|",
	 },
comment_fmt["cangjie5_translator"]={ 
	dbname= "cangjie5" 
	pattern= {
		"xlit|abcdefghijklmnopqrstuvwxyz~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
	 },
 }
-- rime_user/build/cangjie6liu_ext.schema.yaml
comment_fmt["cangjie6liu_ext_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie6liu_ext_reverse_lookup"]={ 
	dbname= "cangjie6liu.extended" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片～|",
	 },
comment_fmt["cangjie6liu_ext_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie6liu_ext_translator"]={ 
	dbname= "cangjie6liu.extended" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片～|",
	 },
comment_fmt["cangjie6liu_ext_vcode"]={ 
	dbname= "cangjie6liu" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片～|",
	 },
 }
-- rime_user/build/cangjie6liu.schema.yaml
comment_fmt["cangjie6liu_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie6liu_reverse_lookup"]={ 
	dbname= "cangjie6liu" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片～|",
	 },
comment_fmt["cangjie6liu_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["cangjie6liu_translator"]={ 
	dbname= "cangjie6liu" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片～|",
	 },
comment_fmt["cangjie6liu_vcode"]={ 
	dbname= "cangjie6liu" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片～|",
	 },
 }
-- rime_user/build/cangjie6.schema.yaml
comment_fmt["cangjie6_jyutping_reverse_lookup"]={ 
	dbname= "cangjie6.extended" 
	pattern= {
		"xform/$/〕=-/",
		"xform/^/〔/",
		"xlit|abcdefghijklmnopqrstuvwxyz |日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片、|",
	 },
comment_fmt["cangjie6_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/ /-/",
		"xform/^(.*)$/(\1)拼/",
	 },
comment_fmt["cangjie6_pinyin_reverse_lookup"]={ 
	dbname= "cangjie6.extended" 
	pattern= {
		"xform/$/〕-/",
		"xform/^/〔/",
		"xlit|abcdefghijklmnopqrstuvwxyz |日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片、|",
	 },
comment_fmt["cangjie6_reverse_lookupall"]={ 
	dbname= "cangjie6.extended" 
	pattern= {
		"xform/$/〕-/",
		"xform/^/---〔/",
		"xlit|abcdefghijklmnopqrstuvwxyz |日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片、|",
	 },
comment_fmt["cangjie6_translator"]={ 
	dbname= "cangjie6.extended" 
	pattern= {
		"xlit|abcdefghijklmnopqrstuvwxyz~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片・|",
		"xform/^(.*)$/--(\1)/",
	 },
 }
-- rime_user/build/combo_pinyin_kbcon.schema.yaml
 }
-- rime_user/build/combo_pinyin.schema.yaml
 }
-- rime_user/build/liur.schema.yaml
comment_fmt["liur_fixed"]={ 
	dbname= "liur.extended" 
	pattern= {
		"xform/^~(.+)$/>[$1]",
	 },
comment_fmt["liur_liurqry"]={ 
	dbname= "liur.extended" 
	pattern= {
		"xform/^~(.+)$/>[$1]",
	 },
comment_fmt["liur_mkst"]={ 
	dbname= "liur.extended" 
	pattern= {
		"xform/^~(.+)$/>[$1]",
	 },
comment_fmt["liur_phonetic"]={ 
	dbname= "terra_pinyin" 
	pattern= {
		"xlit|abcdefghijklmnopqrstuvwxyz[];',.|abcdefghijklmnopqrstuvwxyz[];',.|",
	 },
comment_fmt["liur_phonetic_reverse_lookup"]={ 
	dbname= "terra_pinyin" 
	pattern= {
		"xform/e?r5$/er5/",
		"xform/iu/iou/",
		"xform/ui/uei/",
		"xform/ong/ung/",
		"xform/yi?/i/",
		"xform/wu?/u/",
		"xform/iu/v/",
		"xform/([jqx])u/$1v/",
		"xform/([iuv])n/$1en/",
		"xform/zh/Z/",
		"xform/ch/C/",
		"xform/sh/S/",
		"xform/ai/A/",
		"xform/ei/I/",
		"xform/ao/O/",
		"xform/ou/U/",
		"xform/ang/K/",
		"xform/eng/G/",
		"xform/an/M/",
		"xform/en/N/",
		"xform/er/R/",
		"xform/eh/E/",
		"xform/([iv])e/$1E/",
		"xform/1//",
		"xlit|bpmfdtnlgkhjqxZCSrzcsiuvaoeEAIOUMNKGR2345|ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄧㄨㄩㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦˊˇˋ˙|",
		"xform/ /} {/",
		"xform/^/ {",
		"xform/$/}/",
	 },
comment_fmt["liur_translator"]={ 
	dbname= "liur.extended" 
	pattern= {
		"xform/^~(.+)$/>[$1]",
	 },
 }
-- rime_user/build/luna_pinyin.schema.yaml
comment_fmt["luna_pinyin_reverse_lookup"]={ 
	dbname= "stroke" 
	pattern= {
		"xform/([nl])v/$1ü/",
	 },
 }
-- rime_user/build/luna_quanpin.schema.yaml
comment_fmt["luna_quanpin_reverse_lookup"]={ 
	dbname= "stroke" 
	pattern= {
		"xform/([nl])v/$1ü/",
	 },
 }
-- rime_user/build/newcjliu1.schema.yaml
comment_fmt["newcjliu1_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xform/^(.*)$/［\1］倉/",
	 },
comment_fmt["newcjliu1_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["newcjliu1_reverse_lookup"]={ 
	dbname= "newcjliu" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
	 },
comment_fmt["newcjliu1_reverse_lookup_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xform/^(.*)$/［\1］倉/",
	 },
comment_fmt["newcjliu1_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["newcjliu1_translator"]={ 
	dbname= "newcjliu" 
	pattern= {
		"xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
	 },
 }
-- rime_user/build/newcjliu_ext.schema.yaml
comment_fmt["newcjliu_ext_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xform/^(.*)$/［\1］倉/",
	 },
comment_fmt["newcjliu_ext_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["newcjliu_ext_reverse_lookup"]={ 
	dbname= "newcjliu.extended" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
	 },
comment_fmt["newcjliu_ext_reverse_lookup_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xform/^(.*)$/［\1］倉/",
	 },
comment_fmt["newcjliu_ext_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["newcjliu_ext_translator"]={ 
	dbname= "newcjliu.extended" 
	pattern= {
		"xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
	 },
 }
-- rime_user/build/newcjliu.schema.yaml
comment_fmt["newcjliu_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xform/^(.*)$/［\1］倉/",
	 },
comment_fmt["newcjliu_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["newcjliu_reverse_lookup"]={ 
	dbname= "newcjliu" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
	 },
comment_fmt["newcjliu_reverse_lookup_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xform/^(.*)$/［\1］倉/",
	 },
comment_fmt["newcjliu_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["newcjliu_translator"]={ 
	dbname= "newcjliu" 
	pattern= {
		"xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
	 },
 }
-- rime_user/build/stenotype.schema.yaml
 }
-- rime_user/build/stroke.schema.yaml
comment_fmt["stroke_reverse_lookup"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xlit/hspnz/一丨丿丶乙/",
	 },
comment_fmt["stroke_translator"]={ 
	dbname= "stroke" 
	pattern= {
		"xform/~//",
		"xlit/hspnz/一丨丿丶乙/",
	 },
 }
-- rime_user/build/terra_pinyin.schema.yaml
comment_fmt["terra_pinyin_reverse_lookup"]={ 
	dbname= "stroke" 
	pattern= {
		"xform ([aeiou])(ng?|r)([1234]) $1$3$2",
		"xform ([aeo])([iuo])([1234]) $1$3$2",
		"xform a1 ā",
		"xform a2 á",
		"xform a3 ǎ",
		"xform a4 à",
		"xform e1 ē",
		"xform e2 é",
		"xform e3 ě",
		"xform e4 è",
		"xform o1 ō",
		"xform o2 ó",
		"xform o3 ǒ",
		"xform o4 ò",
		"xform i1 ī",
		"xform i2 í",
		"xform i3 ǐ",
		"xform i4 ì",
		"xform u1 ū",
		"xform u2 ú",
		"xform u3 ǔ",
		"xform u4 ù",
		"xform v1 ǖ",
		"xform v2 ǘ",
		"xform v3 ǚ",
		"xform v4 ǜ",
		"xform/([nljqxy])v/$1ü/",
		"xform/eh[0-5]?/ê/",
		"xform/([a-z]+)[0-5]/$1/",
	 },
comment_fmt["terra_pinyin_translator"]={ 
	dbname= "terra_pinyin" 
	pattern= {
		"xform ([aeiou])(ng?|r)([1234]) $1$3$2",
		"xform ([aeo])([iuo])([1234]) $1$3$2",
		"xform a1 ā",
		"xform a2 á",
		"xform a3 ǎ",
		"xform a4 à",
		"xform e1 ē",
		"xform e2 é",
		"xform e3 ě",
		"xform e4 è",
		"xform o1 ō",
		"xform o2 ó",
		"xform o3 ǒ",
		"xform o4 ò",
		"xform i1 ī",
		"xform i2 í",
		"xform i3 ǐ",
		"xform i4 ì",
		"xform u1 ū",
		"xform u2 ú",
		"xform u3 ǔ",
		"xform u4 ù",
		"xform v1 ǖ",
		"xform v2 ǘ",
		"xform v3 ǚ",
		"xform v4 ǜ",
		"xform/([nljqxy])v/$1ü/",
		"xform/eh[0-5]?/ê/",
		"xform/([a-z]+)[0-5]/$1/",
	 },
 }
-- rime_user/build/whaleliu_ext.schema.yaml
comment_fmt["whaleliu_ext_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xlit|?~ |？~，|",
		"xform/^(.*)$/\1 倉--/",
	 },
comment_fmt["whaleliu_ext_cangjie6liu"]={ 
	dbname= "cangjie6liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片～|",
		"xlit|?~ |？~，|",
		"xform/^(.*)$/［\1］-蒼-/",
	 },
comment_fmt["whaleliu_ext_newcjliu"]={ 
	dbname= "newcjliu" 
	pattern= {
		"xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
	 },
comment_fmt["whaleliu_ext_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xlit|?~ |？~，|",
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["whaleliu_ext_reverse_lookup"]={ 
	dbname= "whaleliu.extended" 
	pattern= {
		"xlit|?~ |？~，|",
		"xform/^(.+)$/〔\1〕r/",
		"xlit|~dmatwfyzljxiekbhsocrugqnpv[];,|～日月金木水火土竹戈十大中一弓人心手口尸廿山女田糸卜魚左右虫羊|",
	 },
comment_fmt["whaleliu_ext_reverse_lookup_cangjie5liu"]={ 
	dbname= "whaleliu.extended" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xlit|?~ |？~，|",
		"xform/^(.*)$/［\1］倉-revlk/",
		"xform/^$/none 倉/",
	 },
comment_fmt["whaleliu_ext_reverse_lookup_cangjie6liu"]={ 
	dbname= "cangjie6liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田止卜片～|",
		"xlit|?~ |？~，|",
		"xform/^(.*)$/［\1］---蒼-/",
	 },
comment_fmt["whaleliu_ext_reverse_lookup_newcjliu"]={ 
	dbname= "newcjliu" 
	pattern= {
		"xlit|',./;?[]dmatwfyzljxiekbhsocrugqnpv|、，。／；？「」日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜言|",
		"xform/^(.*)$/［\1］---新-/",
	 },
comment_fmt["whaleliu_ext_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xlit|?~ |？~，|",
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["whaleliu_ext_translator"]={ 
	dbname= "whaleliu.extended" 
	pattern= {
		"xform/^(.+)$/\1 /",
		"xlit|~dmatwfyzljxiekbhsocrugqnpv[];,|～日月金木水火土竹戈十大中一弓人心手口尸廿山女田糸卜魚左右虫羊|",
	 },
 }
-- rime_user/build/whaleliu.schema.yaml
comment_fmt["whaleliu_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xform/^(.*)$/［\1］倉/",
	 },
comment_fmt["whaleliu_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["whaleliu_reverse_lookup"]={ 
	dbname= "whaleliu" 
	pattern= {
		"xlit|?~|？~|",
		"xform/^(.+)$/〔\1〕-/",
		"xlit|dmatwfyzljxiekbhsocrugqnpv[];,|日月金木水火土竹戈十大中一弓人心手口尸廿山女田糸卜魚左右虫羊|",
	 },
comment_fmt["whaleliu_reverse_lookup_cangjie5liu"]={ 
	dbname= "cangjie5liu" 
	pattern= {
		"xlit|dmatwfyzljxiekbhsocrugqnpv~|日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜符～|",
		"xform/^(.*)$/［\1］倉/",
	 },
comment_fmt["whaleliu_reverse_lookup_pinyin"]={ 
	dbname= "luna_pinyin" 
	pattern= {
		"xform/^(.*)$/［\1］拼/",
	 },
comment_fmt["whaleliu_translator"]={ 
	dbname= "whaleliu" 
	pattern= {
		"xform/^(.+)$/ \1 /",
		"xlit|dmatwfyzljxiekbhsocrugqnpv[];,|日月金木水火土竹戈十大中一弓人心手口尸廿山女田糸卜魚左右虫羊|",
	 },
 }



return comment_tab 
