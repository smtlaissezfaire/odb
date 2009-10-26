module Odb
  module Marshal
    PRIMITIVES = [
      nil,
      false,
      true
    ]
    
    PRIMITIVE_MAP = {
      nil   => ObjectFormat::Primitive::NIL,
      false => ObjectFormat::Primitive::FALSE,
      true  => ObjectFormat::Primitive::TRUE
    }
    
    class << self
      def dump(obj)
        serializer = ObjectFormat.new
        serializer.object_id = 1
        
        case
        when PRIMITIVES.include?(obj)
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
          PRIMITIVES[serializer.primitive]
        else
          eval(serializer.data.class_name).allocate
        end
      end
      
    private
    
      def serialize_primtive(serializer, obj)
        serializer.is_primitive = true
        serializer.primitive = PRIMITIVE_MAP[obj]
      end
      
      def serialize_user_defined_object(serializer, obj)
        serializer.is_primitive = false
        serializer.data = ObjectFormat::UserDefinedObject.new
        serializer.data.class_name = obj.class.to_s
      end
    end
  end
end