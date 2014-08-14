#!/usr/bin/ruby
# encoding: utf-8

#use: gpsinfo.rb * <= to get information out of all images in current directory
 
require 'exifr'
 
ARGV.each {|arg|
  next unless arg.downcase.end_with? "jpg"
            
  exif =  EXIFR::JPEG.new(arg)
  if(exif.gps)
    puts "%s [%s %s]" % [arg, exif.gps.latitude, exif.gps.longitude]
  else
    puts "%s no GPS info" % arg
  end
}
