# encoding: utf-8
require "CSV"

if(ARGV.size != 4)
  puts "Aufruf: incvs.rb <input.cvs> <ids.txt> <nameOfMatchingField> <name>"
  exit
end

input = ARGV[0]
puts "Input: #{input}"
idFile = ARGV[1]
fieldName = ARGV[2]
name = ARGV[3]

ids = Array.new

fileOk = "#{name}_in.csv"
fileOverflow = "#{name}_overflow.csv"
fileMissing = "#{name}_missing.csv"


# read id file
file = File.new(idFile, "r")
while (line = file.gets)
 ids << line.to_i
end
file.close

puts "Size of ID-File: #{ids.size}"

header = File.new(input, "r")
raw = header.gets
raw.gsub!("\"", "")
puts "read header line is: '#{raw}'"
headerLine = raw.strip.split(";")
header.close

puts headerLine

# read cvs file
CSV.open(fileOk, "wb", {:col_sep => ";"}) do |csvOK|
CSV.open(fileMissing, "wb", {:col_sep => ";"}) do |csvMissing|

  csvOK << headerLine
  csvMissing << headerLine

  CSV.foreach(input, :headers => true, :col_sep => ";") do |row|

   # puts row[fieldName]
    if ids.include? row[fieldName].to_i then
      csvOK << row
      puts row
    else
      csvMissing << row
    end

    end
end
end