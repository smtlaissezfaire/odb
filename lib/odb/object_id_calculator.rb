module Odb
  class ObjectIdCalculator
    PRIMITIVE_OBJECTS = {
      nil   => 0,
      true  => 1,
      false => 2
    }
    
    START_ODB_ID = 99
    
    class << self
      def reset_object_hash!
        @last_object_id = START_ODB_ID
      end
      
      def object_id(obj)
        if val = object_id_hash[obj.object_id]
          val
        else
          store_object(obj.object_id, next_odb_id)
        end
      end
      
    private
      
      def store_object(ruby_object_id, odb_object_id)
        object_id_hash[ruby_object_id] = odb_object_id
      end
      
      def object_id_hash
        @object_id_hash ||= default_object_id_hash
      end
      
      def default_object_id_hash
        hash = {}
        
        PRIMITIVE_OBJECTS.each do |obj, odb_id|
          hash[obj.object_id] = odb_id
        end
        
        hash
      end
      
      def last_odb_id
        @last_object_id ||= START_ODB_ID - 1
      end
      
      def next_odb_id
        @last_object_id = last_odb_id + 1
      end
    end
    
    def initialize(obj)
      @obj = obj
      find_or_set_object_id(obj)
    end
    
    def find_or_set_object_id(obj)
      @object_id = self.class.object_id(obj)
    end
    
    attr_reader :object_id
  end
end