# music_extractor.rb
#
# author: Matthew Nielsen
#
# instructions: ruby music_extractor.rb <source> <destination>

require "fileutils"

class Extractor
  
  def initialize(source, destination)
    @source = source
    @destination = destination
  end
  
  def run
    extract(@source, @destination)
  end
  
  # a recursive algorithm that checks every directory for song files
  # song files are copied to the destination directory
  def extract(source, destination)
    if !File.directory?(source)
      if source.include?(".mp3") || source.include?(".m4a")
        FileUtils.cp(source, destination)
      end
    else
      Dir.foreach(source) do |item|
        unless item == "." || item == ".."
          print item, "\n"
          extract(source + "/" + item, destination)
        end
      end
    end
  end
  
end

if __FILE__ == $0
  source, destination = ARGV
  
  extractor = Extractor.new(source, destination)
  extractor.run
end
