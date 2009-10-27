require 'bert'

module Odb
  module Marshal
    PRIMITIVE_CLASSES = [
      NilClass,
      FalseClass,
      TrueClass,
      Fixnum,
      Float,
      Symbol,
      Time,
      Regexp
    ]
    
    TYPES = [
      PRIMITIVE  = 0,
      USER_CLASS = 1
    ]
    
    class << self
      # [0, "NilClass",  primitive-obj]
      # [1, "UserClass", ivar-hash]
      def dump(obj)
        klass = obj.class
      
        if PRIMITIVE_CLASSES.include?(klass)
          encode(t[PRIMITIVE, klass.to_s, obj])
        else
          encode(t[USER_CLASS, klass.to_s])
        end
      end
    
      def load(str)
        type, klass, data = decode(str)
      
        if type == PRIMITIVE
          data
        else
          eval(klass).allocate
        end
      end
      
    private
    
      def encode(tuple)
        BERT.encode(tuple)
      end
      
      def decode(str)
        BERT.decode(str)
      end
    end
  end
end