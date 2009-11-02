module Odb
  module Proxy
    class Array < ::Array
      def [](index)
        Odb::Object.read(super)
      end

      def each(&block)
        to_a.each(&block)
      end

      def first
        self[0]
      end

      def last
        self[self.size - 1]
      end

      alias_method :object_ids, :to_a

      def to_a
        object_ids.map { |e| self[e] }
      end

      def inspect
        object_ids.map { |id| "object_id:#{id}" }.inspect.gsub('"', '')
      end
    end
  end
end