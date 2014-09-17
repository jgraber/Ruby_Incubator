#!/usr/bin/ruby
# encoding: utf-8

# doc: 
# http://www.ruby-doc.org/core-1.9.3/File.html#method-i-size

require 'pp'

Dir.entries(".").sort_by{|c| File.stat(c).ctime}.each do |f|

  if (f != ".") && (f != "..") && (!f.to_s.start_with? "_") && (!f.to_s.end_with? ".sh")
    folder = "_" + File.stat(f).ctime.strftime("%Y-%m-%d")

    if !File.exists? folder 
      puts "Create folder #{folder}" 
      Dir.mkdir(folder)
    end
    
    fescaped = f.gsub("'"){"\\'"}
    fescaped = fescaped.gsub(" "){"\\ "}
    fescaped = fescaped.gsub("("){"\\("}
    fescaped = fescaped.gsub(")"){"\\)"}
    fescaped = fescaped.gsub("-"){"\\-"}
    fescaped = fescaped.gsub("="){"\\="}
    fescaped = fescaped.gsub("&"){"\\&"}
    fescaped = fescaped.gsub(">"){"\\>"}
    
    cmd = "mv %s %s " % [fescaped, folder]
    puts cmd
    `#{cmd}`

  end
end
