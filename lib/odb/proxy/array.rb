module Odb
  module Proxy
    class Array
      include Enumerable

      def initialize(object_ids = [])
        @object_cache = {}
        @object_ids = Array(object_ids)
      end

      attr_reader :object_ids

      def <<(object_id)
        @object_ids << object_id
      end

      def each
        @object_ids.each do |oid|
          yield lookup_element(oid)
        end
      end

      def [](index)
        lookup_element @object_ids[index]
      end

      def first
        lookup_element @object_ids.first
      end

      def last
        lookup_element @object_ids.last
      end

      def to_a
        @object_ids.map do |oid|
          lookup_element oid
        end
      end

      def empty?
        @object_ids.empty?
      end

      def inspect
        returning String.new do |str|
          str << "<#{self.class} "
          str << @object_ids.map { |id| "object_id:#{id}" }.inspect.gsub('"', '')
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