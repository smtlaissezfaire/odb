module Odb
  class Installer
    def self.install(path)
      new(path).install
    end
    
    def initialize(dir)
      @base_dir = dir
    end
    
    def join(*args)
      File.join(*args)
    end
    
    def install
      if File.exists?(join(@base_dir, "odb"))
        raise LoadError, "ODB directory already exists!"
      else
        Dir.mkdir(join(@base_dir, "odb"))
        FileUtils.touch(join(@base_dir, "odb", "objects"))
        FileUtils.touch(join(@base_dir, "odb", "objects.idx"))
      end
    end
  end
end
