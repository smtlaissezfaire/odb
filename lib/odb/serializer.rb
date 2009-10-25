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
      str = "class:#{obj.class}"
      
      ivars_and_object_ids(obj).each do |var, object_id|
        str << ",#{var}:#{object_id}"
      end
      
      str
    end
    
  private
  
    def ivars_and_object_ids(obj)
      obj.instance_variables.map do |var|
        value     = obj.instance_variable_get(var)
        object_id = object_id(value)
        
        [var, object_id]
      end
    end

    def object_id(obj)
      ObjectIdCalculator.new(obj).object_id
    end
  
    def primitve?(obj)
      PRIMITIVES.include?(obj)
    end
  end
end