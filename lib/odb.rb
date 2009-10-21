require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :database_path
  end
  
  using :Serialize
  using :Version
end