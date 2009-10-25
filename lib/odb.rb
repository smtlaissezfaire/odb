require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :root
    
    def join(*args)
      File.join(*args)
    end
    
    def init(dir = Dir.getwd)
      if File.exists?(join(dir, "odb"))
        raise LoadError, "ODB directory already exists!"
      else
        Dir.mkdir(join(dir, "odb"))
        FileUtils.touch(join(dir, "odb", "objects"))
        FileUtils.touch(join(dir, "odb", "objects.idx"))
      end
    end
  end
  
  using :ObjectFormat, :file => "object_format.pb"
  using :ObjectIdCalculator
  using :Serializer
  using :Version
end