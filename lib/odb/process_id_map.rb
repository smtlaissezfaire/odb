module Odb
  unless defined?(ProcessIdMap)
    class << ProcessIdMap = Hash.new
      def [](obj)
        super(obj.object_id)
      end

      def []=(obj, value)
        super(obj.object_id, value)
      end
    end
  end
end
