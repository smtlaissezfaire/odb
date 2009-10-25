module Odb
  class Serializer
    PRIMITIVES = [
      true,
      false,
      nil
    ]
    
    def self.dump(obj)
      new.dump(obj)
    end
    
    def dump(obj)
      if primitve?(obj)
        serialize_primitive(obj)
      else
        serialize_user_defined_object(obj)
      end
    end
    
    def serialize_primitive(obj)
      Marshal.dump(obj)
    end
    
    def serialize_user_defined_object(obj)
      "class:UserDefined"
    end
    
  private
  
    def primitve?(obj)
      PRIMITIVES.include?(obj)
    end
  end
end