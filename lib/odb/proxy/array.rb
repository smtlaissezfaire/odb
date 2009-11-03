module Odb
  module Proxy
    class Array
      include Enumerable
      include ObjectCache

      def initialize(object_ids = [])
        super
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
    end
  end
end
