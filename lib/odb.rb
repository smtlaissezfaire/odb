require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :root
    
    def init(path = Dir.getwd)
      Installer.install(path)
    end
  end
  
  ProcessIdMap = Hash.new
  
  using :FileHelpers
  using :Path
  using :Installer
  using :ObjectIndex
  using :Marshal
  using :Version
end