require "using"

module Odb
  extend Using

  class RecordNotFound < StandardError; end

  class << self
    def init path = Dir.getwd
      Installer.install(path)
    end
    
    attr_reader :path
    
    def path=(path)
      @path = path ? Odb::Path.new(path) : nil
    end
  end

  using :ProcessIdMap
  using :FileHelpers
  using :ObjectFile
  using :ObjectIndexFile
  using :Path
  using :Installer
  using :Object
  using :Marshal
  using :Version

  using :ObjectDataFile
  using :ObjectIdFile
end
