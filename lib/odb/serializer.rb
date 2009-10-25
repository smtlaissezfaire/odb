require 'facets/kernel/returning'

module Odb
  class Serializer
    PRIMITIVE_CLASSES = [
      TrueClass,
      FalseClass,
      NilClass,
      Fixnum,
      Bignum,
      Float
    ]
    
    def self.dump(obj)
      new.dump(obj)
    end
    
    def self.load(str)
      new.load(str)
    end
    
    def dump(obj)
      if primitve?(obj)
        serialize_primitive(obj)
      else
        serialize_user_defined_object(obj)
      end
    end
    
    def load(str)
      klass, *ivars = str.split(",")
      _, klass_name = klass.split(":")
      
      returning eval(klass_name).new do |obj|
        if ivars.any?
          ivars.each do |ivar_group|
            ivar_name, odb_object_id = ivar_group.split(":")
            obj.instance_variable_set(ivar_name, true)
          end
        end
      end
    end
    
  private
  
    def serialize_primitive(obj)
      Marshal.dump(obj)
    end
  
    def serialize_user_defined_object(obj)
      returning String.new do |str|
        str << "class:#{obj.class}"
    
        ivars_and_object_ids(obj).each do |var, object_id|
          str << ",#{var}:#{object_id}"
        end
      end
    end
  
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
      PRIMITIVE_CLASSES.include?(obj.class)
    end
  end
end