#!/usr/bin/env ruby
#
# comment.rb
# Copyright (C) 2020 Shewer Lu <shewer@gmail.com>
#
# Distributed under terms of the MIT license.
#


require 'yaml'
Head= %q[require("format")(%s)]  

if __FILE__ == $0
  file=ARGV[0]
  Segment=ARGV[1] || "translator"
  Comment="comment_format"

  puts file
  schema=YAML.load_file(file)
  #p schema
  schema.keys.each{|key| 
    comment_ar= schema[key][Comment]   if schema[key].is_a?( Hash)  
    if comment_ar
      out= Head % comment_ar.map{|l| "\n\t\"#{l}\" , " }.join("")
      puts "--   #{file}:#{key}----", out
    end 
  }

end


