module Odb
  class Path
    include FileHelpers
    
    def initialize(start_dir)
      @start_dir = start_dir
    end
    
    def odb_dir
      join @start_dir, "odb"
    end
    
    def objects_file
      join @start_dir, "odb", "objects"
    end
    
    def objects_index
      join @start_dir, "odb", "objects.idx"
    end
  end
end