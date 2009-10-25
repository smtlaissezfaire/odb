require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :root
  end
  
  using :ObjectIdCalculator
  using :Serializer
  using :Version
end