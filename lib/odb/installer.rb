module Odb
  class Installer
    def self.install(path)
      new(path).install
    end
    
    def initialize(dir)
      @base_dir = dir
    end
    
    def install
      if file_exists? @base_dir, "odb"
        raise LoadError, "ODB directory already exists!"
      end

      mkdir @base_dir, "odb"
      touch @base_dir, "odb", "objects"
      touch @base_dir, "odb", "objects.idx"
    end
    
  private
  
    def file_exists?(*args)
      File.exists? join(*args)
    end
  
    def mkdir(*args)
      Dir.mkdir join(*args)
    end
  
    def touch(*args)
      FileUtils.touch join(*args)
    end
  
    def join(*args)
      File.join(*args)
    end
  end
end
