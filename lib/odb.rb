require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :database_path
    attr_accessor :root
  end
  
  using :Serialize
  using :Version
end