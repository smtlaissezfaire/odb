module Odb
  module Proxy
    class Hash
      include ObjectCache

      def initialize(hash={})
        super
        @hash = hash
      end

      def has_key?(key)
        @hash.has_key?(key)
      end

      def [](key)
        if object_id = @hash[key]
          lookup_element object_id
        else
          nil
        end
      end

      def []=(key, value)
        @hash[key] = value
      end

      alias_method :store, :[]

      def ==(other)
        other.respond_to?(:object_proxy_hash) &&
          @hash == other.object_proxy_hash
      end

      def clear
        @hash.clear
      end

      def empty?
        @hash.empty?
      end

    protected

      def object_proxy_hash
        @hash
      end
    end
  end
end
