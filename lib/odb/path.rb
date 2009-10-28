module Odb
  class Path
    include FileHelpers
    
    def initialize file_system_path
      @file_system_path = file_system_path
    end
    
    attr_reader :file_system_path
    
    def odb_dir
      join @file_system_path, "odb"
    end
    
    def objects_file
      join @file_system_path, "odb", "objects"
    end
    
    def objects_index
      join @file_system_path, "odb", "objects.idx"
    end
    
    def ==(other)
      if other.respond_to?(:file_system_path)
        file_system_path == other.file_system_path
      else
        false
      end
    end
  end
end