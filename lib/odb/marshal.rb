require 'bert'
require 'facets/kernel/returning'

module Odb
  class Marshal
    class << self
      # [0, "NilClass",  primitive-obj]
      # [1, "UserClass", ivar-hash]
      def dump obj
        new.dump(obj)
      end
    
      def load str
        new.load(str)
      end
    end
    
    PRIMITIVE_CLASSES = [
      NilClass,
      FalseClass,
      TrueClass,
      Fixnum,
      Float,
      String,
      Symbol,
      Time,
      Regexp
    ]
    
    PROXY_CLASSES = [
      Array
    ]

    TYPES = [
      PRIMITIVE   = 0,
      USER_CLASS  = 1,
      PROXY_CLASS = 2
    ]
    
    def load str
      type, klass, data = decode(str)
    
      case type
      when PRIMITIVE
        load_primitive(klass, data)
      when PROXY_CLASS
        load_proxy_class(data)
      else
        load_user_defined_class(klass, data)
      end
    end
    
    def dump obj
      klass = obj.class
    
      if PRIMITIVE_CLASSES.include?(klass)
        encode(t[PRIMITIVE, klass.to_s, obj])
      elsif PROXY_CLASSES.include?(klass)
        encode(t[PROXY_CLASS, klass.to_s, proxy_data(obj)])
      else
        encode(t[USER_CLASS, klass.to_s, ivars_for(obj)])
      end
    end
      
  private

    def load_proxy_class(data)
      Odb::Proxy::Array.new(data)
    end

    def proxy_data(obj)
      obj.map { |element| Odb::Object.write(element) }
    end
  
    def load_primitive _, data
      data
    end
    
    def load_user_defined_class(klass_name, data)
      UserDefinedLoader.load(klass_name, data)
    end
    
    def ivars_for obj
      returning Hash.new do |hash|
        obj.instance_variables.each do |variable|
          hash[variable] = object.write(obj.instance_variable_get(variable))
        end
      end
    end
  
    def encode tuple
      BERT.encode(tuple)
    end
    
    def decode str
      BERT.decode(str)
    end
    
    def object
      @object = Object.new
    end
    
    class UserDefinedLoader
      def self.load klass_name, data
        new(klass_name, data).load
      end
      
      def initialize klass_name, data
        @klass_name = klass_name
        @data       = data
      end
      
      def load
        returning new_instance do |obj|
          load_ivars(obj)
        end
      end
    
    private
    
      def new_instance
        klass.allocate
      end
    
      def klass
        Object.instance_eval("::#{@klass_name}", __FILE__, __LINE__)
      end
      
      def load_ivars obj
        ivars.each do |key, value|
          obj.instance_variable_set(key, value)
        end
      end
      
      def ivars
        returning Hash.new do |hash|
          @data.each do |key, oid|
            hash[key] = object_loader.read(oid)
          end
        end
      end

      def object_loader
        @object_loader = Odb::Object.new
      end
    end
  end
end