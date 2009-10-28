module Odb
  class Installer
    include FileHelpers
    
    def self.install path
      new(path).install
    end
    
    def initialize dir
      @path = Path.new(dir)
    end
    
    def install
      if file_exists? @path.odb_dir
        raise LoadError, "ODB directory already exists!"
      end
      
      mkdir @path.odb_dir
      touch @path.objects_file
      touch @path.objects_index
    end
  end
end
