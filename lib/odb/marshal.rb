module Odb
  module Marshal
    PRIMITIVE_CLASSES = [
      NilClass,
      FalseClass,
      TrueClass,
      Fixnum,
      Float,
      Bignum
    ]
    
    OBJ_TO_PRIMITIVE_STRING = {
      nil   => ObjectFormat::Primitive::NIL,
      false => ObjectFormat::Primitive::FALSE,
      true  => ObjectFormat::Primitive::TRUE
    }
    
    PRIMITIVE_STRING_TO_OBJ = {}
    
    OBJ_TO_PRIMITIVE_STRING.each do |key, value|
      PRIMITIVE_STRING_TO_OBJ[value] = key
    end
    
    class << self
      def dump(obj)
        serializer = ObjectFormat.new
        serializer.object_id = 1
        
        case
        when PRIMITIVE_CLASSES.include?(obj.class)
          serialize_primtive(serializer, obj)
        else
          serialize_user_defined_object(serializer, obj)
        end
        
        serializer.serialize_to_string
      end
    
      def load(str)
        serializer = ObjectFormat.new
        serializer.parse_from_string(str)

        if serializer.is_primitive
          load_primitive(serializer)
        else
          load_user_defined_object(serializer)
        end
      end
      
    private
    
      def load_user_defined_object(serializer)
        eval(serializer.data.class_name).allocate
      end
    
      def load_primitive(serializer)
        if serializer.primitive_data.empty?
          PRIMITIVE_STRING_TO_OBJ[serializer.primitive]
        else
          eval(serializer.primitive_data)
        end
      end
    
      def serialize_primtive(serializer, obj)
        serializer.is_primitive = true
        
        if OBJ_TO_PRIMITIVE_STRING.has_key?(obj)
          serializer.primitive = OBJ_TO_PRIMITIVE_STRING[obj]
        else
          serializer.primitive_data = obj.inspect
        end
      end
      
      def serialize_user_defined_object(serializer, obj)
        serializer.is_primitive = false
        serializer.data = ObjectFormat::UserDefinedObject.new
        serializer.data.class_name = obj.class.to_s
      end
    end
  end
end