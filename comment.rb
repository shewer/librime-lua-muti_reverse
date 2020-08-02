#!/usr/bin/env ruby
#
# comment.rb
# Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
#
# Distributed under terms of the MIT license.
#


require 'yaml'
Head= %q[%s =require("format")(%s)]  
Segment=ARGV[1] || "translator"
Comment="comment_format"
Dictionary="dictionary"
MTranslator="translator"

Tab="\t"
def getrvt( schema)
  schema["engine"]["translators"]
    .select {|l| l =~ /\s*reverse_lookup_translator/ }
    .map{|l| l.split("@")[1] || "reverse_lookup" }
end  

def get_comment(filename)
  schema=YAML.load_file(filename)
  schema_id=schema["schema"]["schema_id"]
  # 找出 reverse_lookup_translator  segmentor 
  # 此 segment dbname 要調 translator/directionary  
  main_translator= schema["translator"][Dictionary]
  rvt= getrvt(schema ) 
  # 建立 lua table hash data
  #   schema_id_seg_name= {dbname: direction , pattern: [comment_fmt ]
  # 調出  次目錄 為 Hash 
  schema.select {  |seg ,seg_value|
    seg_value .is_a?( Hash)  && seg_value[Comment] && seg_value[Dictionary]
  }
    .map{  |seg ,seg_value|   # 轉換 成 lua tab 
    ["#{schema_id}_#{seg}" , 
     { # 如果 seg 為 reverse_lookup_translator ,  dbname 改為 translator/dictionary
      "dbname"=> ( rvt.include?(seg)) ? main_translator : "#{seg_value[Dictionary]}" , 
      "pattern"=> seg_value[Comment]}  ] 
      }
      .to_h




end 
#
#
#    schema_id_segment
def lua_comment_fmt( comment, tablename="")
  nest=0

  str="" 

  comment.reduce(str) {|str ,(schema_seg,v)| 
    str << "#{tablename}[\"#{schema_seg}\"]={ \n" 
    nest +=1
    str << "#{Tab*nest}dbname= \"#{ v["dbname"] }\", \n" 
    str << "#{Tab*nest}pattern= " << "{\n" 
    nest+=1 
    v["pattern"].reduce(str)  {|str1,line|    
      str1 <<    "#{Tab*nest}\"#{line}\",\n"       
    }
    nest-=1
    str << "#{Tab*nest} },\n"       
    #puts str
    nest -=1
    str <<  "#{Tab*nest} }\n"      
  }

end 



if __FILE__ == $0
  file=ARGV[0]
  tabname=ARGV[1]

  puts lua_comment_fmt(get_comment(file ),tabname  )
end 



