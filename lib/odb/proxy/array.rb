module Odb
  module Proxy
    class Array < ::Array
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

    private

      def lookup_element(object_id)
        Odb::Object.read(object_id)
      end
    end
  end
end