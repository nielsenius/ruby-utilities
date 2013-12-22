# duplicate_deleter.rb
#
# author: Matthew Nielsen
#
# ruby duplicate_deleter.rb <source> <XML list>

require "set"

class Deleter
  
  def initialize(source, xml)
    @source = source
    @xml = xml
    @titles = Set.new
  end
  
  def run
    add_titles
    delete_duplicates
  end
  
  # runs through xml file and adds titles to a set
  # a set is used because membership can be verified in O(1) time
  def add_titles
    File.foreach(@xml) do |row|
      if row.include?("<key>Name</key>")
        if row.include?("(")
          idx = row.index("(") - 1
        else
          idx = row.rindex("<") - 1
        end
        
        @titles.add(row[26..idx].downcase)
      end
    end
  end
  
  # every title in the source directory is checked against the set
  # duplicate items are deleted
  def delete_duplicates
    Dir.foreach(@source) do |item|
      unless item == "." || item == ".."
        first = item.index(/[a-zA-Z]/)
        
        if item.include?("(")
          last = item.index("(") - 1
        else
          last = item.index(".") - 1
        end

        if @titles.include?(item[first..last].downcase)
          puts item
          File.delete(@source + "/" + item)
        end
      end
    end
  end
  
end

if __FILE__ == $0
  source, xml = ARGV
  
  deleter = Deleter.new(source, xml)
  deleter.run
end
