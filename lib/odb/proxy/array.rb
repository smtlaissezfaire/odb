module Odb
  module Proxy
    class Array < ::Array
      def initialize(array = [])
        @object_cache = {}
        super
      end

      def each
        super do |oid|
          yield lookup_element(oid)
        end
      end

      def [](index)
        lookup_element super
      end

      def first
        lookup_element super
      end

      def last
        lookup_element super
      end

      alias_method :object_ids, :to_a

      def to_a
        object_ids.map do |oid|
          lookup_element oid
        end
      end

      def inspect
        returning String.new do |str|
          str << "<#{self.class} "
          str << object_ids.map { |id| "object_id:#{id}" }.inspect.gsub('"', '')
          str << ">"
        end
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