require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :root
  end
  
  using :ObjectFormat, :file => "object_format.pb"
  using :ObjectIdCalculator
  using :Serializer
  using :Version
end