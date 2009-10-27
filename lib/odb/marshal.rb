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

    # [0, "NilClass",  primitive-obj]
    # [1, "UserClass", ivar-hash]
    def self.dump(obj)
      klass = obj.class
      
      if PRIMITIVE_CLASSES.include?(klass)
        BERT.encode(t[PRIMITIVE, klass.to_s, obj])
      else
        BERT.encode(t[USER_CLASS, klass.to_s])
      end
    end
    
    def self.load(str)
      type, klass, data = BERT.decode(str)
      
      if type == PRIMITIVE
        data
      else
        eval(klass).allocate
      end
    end
  end
end