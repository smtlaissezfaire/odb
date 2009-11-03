module Odb
  module Proxy
    module ObjectCache
      def initialize(*args)
        @object_cache = {}
      end

      def reload
        @object_cache = {}
      end

    private

      def lookup_element(object_id)
        if obj = object_cache(object_id)
          obj
        elsif obj = Odb::Object.read(object_id)
          cache_object(obj, object_id)
          obj
        end
      end

      def object_cache(object_id)
        @object_cache[object_id]
      end

      def cache_object(obj, object_id)
        @object_cache[object_id] = obj
      end
    end
  end
end
