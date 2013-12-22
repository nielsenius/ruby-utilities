# name_tool.rb
#
# author: Matthew Nielsen
#
# ruby name_tool.rb <source>

class NameTool
  
  def initialize(source)
    @source = source
  end
  
  # the name of every video file in the source directory is checked
  def run
    Dir.foreach(@source) do |item|
      # improperly named items are renamed
      unless item =~ /^S0/
        if item.include?(".mp4")
          puts item
          File.rename(@source + "/" + item, @source + "/" + create_new_name(item))
        end
      end
    end
  end
  
  # the file's name is parsed and all extraneous information is left
  # out of the new name
  def create_new_name(original)
    raw = original.split(".")
    
    if raw[4] =~ /^DVD/ || raw[4] =~ /^AC3/
      "#{raw[3]}.mp4"
    else
      if raw[4].include?("DVD")
        "#{raw[3]} - #{raw[4][0..raw[4].index("DVD") - 2]}.mp4"
      elsif raw[4].include?("AC3")
        "#{raw[3]} - #{raw[4][0..raw[4].index("AC3") - 2]}.mp4"
      else
        "#{raw[3]} - #{raw[4]}.mp4"
      end
    end
  end
  
end

if __FILE__ == $0
  source = ARGV[0]
  
  renamer = NameTool.new(source)
  renamer.run
end
