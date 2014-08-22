class IndexMaker

  def create(folder)
    #puts "Start with #{folder}"
    filecontent = "<HTML><HEAD><TITLE>#{folder}</TITLE></HEAD><BODY>"
    Dir.entries(folder).sort_by{|c| c}.each do |f|
      next if f.start_with?(".")

      if File.directory?("#{folder}/#{f}")
        #puts "====> DIR: #{folder}/#{f}"
        create("#{folder}/#{f}")
        next
      end

      filecontent << "<p><a href='./#{f}'>#{f}</a><p>"
    end
    #puts "done with #{folder}"
    filecontent << "</BODY></HTML>"
    File.open("#{folder}/00_Inhalt.html", 'w') {|f| f.write(filecontent) }
  end
end


indexer = IndexMaker.new
indexer.create(ARGV[0])