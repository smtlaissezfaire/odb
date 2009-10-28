module Odb
  unless defined?(ProcessIdMap)
    class << ProcessIdMap = Hash.new
      def get_oid(obj)
        self[obj.object_id]
      end
    
      def set_oid(obj, object_id)
        self[obj.object_id] = object_id
      end
    
      def tracked_object?(obj)
        has_key?(obj.object_id)
      end
    end
  end
end
