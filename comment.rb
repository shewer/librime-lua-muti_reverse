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
Tab="\t"
def get_comment(filename)
  schema=YAML.load_file(filename)
  schema_id=schema["schema"]["schema_id"]
  schema.select {  |k,v|
    v.is_a?( Hash)  && v[Comment] && v[Dictionary]
  }.map{|k,v|   ["#{schema_id}_#{k}" , { "dbname"=> "#{v[Dictionary]}" , "pattern"=> v[Comment]}  ]  }.to_h
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



