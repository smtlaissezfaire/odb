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

      def object_ids
        self
      end

      def to_a
        super.map { |e| self[e] }
      end
    end
  end
end