# start with this command: rspec fileaway_spec.rb

class Rename
  attr_accessor :source, :newName

  def initialize (path)
    @source = path
  end

  def ==(other)
    @source == other.source && @newName == other.newName
  end
end

class Fileaway
  
  def initialize(prefix="")
    @prefix = prefix
    @last_number_path = Hash.new
  end  

  def move(source, target)
    files = find_files_in(source)
    replace_names_with_numbers(files)

    files.each do |entry|
      puts "cp #{entry.source} #{target}/#{entry.newName}"
      `cp #{entry.source} #{target}/#{entry.newName}`
    end
  end

  def find_files_in(source)
  entries = Array.new()
  Dir["#{source}/**/*"].sort.each { |entry| 
    if File.file?(entry)
        entries << Rename.new(entry)
      else File.directory?(entry)
      # puts "%s is a directory" % entry
      end
  }
  entries
  end

  def replace_names_with_numbers(entries)
    current_path = ""
    number = 1
    entries.each do |entry|
      parts = entry.source.split "/"
      filename = parts.pop
      path = parts.join "/"

      if(current_path == path)
        number = number + 1
      else
        current_path = path
        if(@last_number_path.include? current_path)
          number = @last_number_path[current_path] + 1
          #puts "NUMBER: #{number}"
        else
          number = 1
          #puts "NUMBER: Path not in Hash #{path}"
        end       
      end

      @last_number_path[path] = number
      #puts "HASH: #{@last_number_path}"

      newPath = set_number_as_name(path, number, filename)
      entry.newName = get_new_name(newPath)
    end
  end

  def set_number_as_name(path, number, filename)
  path + "/" + "%03d" % number + "." + get_suffix(filename)
  end

  def get_suffix(filename)
  (filename.split ".").pop
  end

  def get_new_name(oldpath)
    name = oldpath.gsub("/","_")

    if @prefix != ""
      @prefix + "_" + name
    else
      name
    end
  end
end


describe "filename" do 
  it "1 is printed as 001" do
    i = 1
    formated = "%03d" % i
    formated.should eq "001"
  end

  it "big numbers are not truncated" do
    i = 1000
    formated = "%03d" % i
    formated.should eq "1000"
  end
end

describe "folder structure" do
  it "file a in folder/ is found" do
    source = "folder"
    f = Fileaway.new 
    entries = f.find_files_in (source)
    entries.should include Rename.new "folder/a"
  end

  it "file can fold in recursive folder" do
    source = "folder"
    f = Fileaway.new
    entries = f.find_files_in (source)
    entries.should =~ [Rename.new("folder/a"), Rename.new("folder/lower/b")]
  end
end

describe "file names" do
  it " / should be replaced with _" do
    f = Fileaway.new
    name = f.get_new_name("a/b/c/d.txt")
    name.should == "a_b_c_d.txt"
  end

  it "should add the prefix with an _" do
    f = Fileaway.new ("pref")
    name = f.get_new_name("a/b/c/d.txt")
    name.should == "pref_a_b_c_d.txt"
  end

  it "should replace the filename with a number" do   
    entries = Array.new
    entries << Rename.new("a/a.txt")
    entries << Rename.new("a/b.jpg")
    entries << Rename.new("b/b.jpg")

    f = Fileaway.new
    f.replace_names_with_numbers(entries)

    aTxt = Rename.new ("a/a.txt")
    aTxt.newName = "a_001.txt"
    aJpg = Rename.new ("a/b.jpg")
    aJpg.newName = "a_002.jpg"
    bJPG = Rename.new ("b/b.jpg")
    bJPG.newName = "b_001.jpg"
    entries.should =~ [aTxt, aJpg, bJPG]
  end

  it "shuld remember last number in folder" do
    entries = Array.new
    entries << Rename.new("a/a.txt")
    entries << Rename.new("a/b/a.jpg")
    entries << Rename.new("a/c.jpg")

    f = Fileaway.new
    f.replace_names_with_numbers(entries)

    aTxt = Rename.new ("a/a.txt")
    aTxt.newName = "a_001.txt"
    aJpg = Rename.new ("a/b/a.jpg")
    aJpg.newName = "a_b_001.jpg"
    bJPG = Rename.new ("a/c.jpg")
    bJPG.newName = "a_002.jpg"
    entries.should =~ [aTxt, aJpg, bJPG]
  end
end

# describe "do work" do
#   it "should work" do
#     f = Fileaway.new "demo"
#     f.move("folder", "output")
#   end
# end

describe "do work" do
  it "should work" do
    f = Fileaway.new "Irland"
    f.move("2014_Maerz", "Irland2014_Maerz")
  end
end
