module Odb
  module Proxy
    class Array < ::Array
      def [](index)
        Odb::Object.read(super)
      end

      def each(&block)
        super do |val|
          yield(self[val])
        end
      end

      def object_ids
        self
      end
    end
  end
end