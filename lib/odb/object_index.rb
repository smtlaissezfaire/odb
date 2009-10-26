require 'facets/kernel/returning'

module Odb
  class ObjectIndex
    def initialize(odb_path)
      @odb_path = odb_path
    end
    
    def current_id
      line_count(objects_file)
    end
    
    def next_id
      current_id + 1
    end
    
  private
  
    def objects_file
      File.join(@odb_path, "objects.idx")
    end
  
    def line_count(*args)
      lines = 0
      File.read(File.join(*args)).each_line do |_|
        lines += 1
      end
      lines
    end
  end
end