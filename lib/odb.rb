require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :root
    
    def init(path = Dir.getwd)
      Installer.install(path)
    end
  end
  
  using :Installer
  using :ObjectFormat, :file => "object_format.pb"
  using :ObjectIdCalculator
  using :Serializer
  using :Version
end