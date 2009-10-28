require "using"

module Odb
  extend Using
  
  class << self
    def init path = Dir.getwd
      Installer.install(path)
    end
  end
  
  ProcessIdMap = Hash.new
  
  using :FileHelpers
  using :Path
  using :Installer
  using :Object
  using :Marshal
  using :Version
end