require "using"

module Odb
  extend Using
  
  class << self
    attr_accessor :root
  end
  
  using :Version
end