#!/usr/bin/ruby
# encoding: utf-8

#use: RandomString.rb Length_of_string 
 
length = ARGV[0].to_i

o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
result = (0...length).map { o[rand(o.length)] }.join
puts result