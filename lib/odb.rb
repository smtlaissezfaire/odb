require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :root
  end
  
  using :Serializer
  using :Version
end