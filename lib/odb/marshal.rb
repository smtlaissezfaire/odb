require 'bert'
require 'base64'
require 'facets/kernel/returning'

module Odb
  module Marshal
    PRIMITIVE_CLASSES = [
      NilClass,
      FalseClass,
      TrueClass,
      Fixnum,
      Float,
      Symbol,
      Time,
      Regexp
    ]
    
    TYPES = [
      PRIMITIVE  = 0,
      USER_CLASS = 1
    ]
    
    class << self
      # [0, "NilClass",  primitive-obj]
      # [1, "UserClass", ivar-hash]
      def dump obj
        klass = obj.class
      
        if PRIMITIVE_CLASSES.include?(klass)
          encode(t[PRIMITIVE, klass.to_s, obj])
        else
          encode(t[USER_CLASS, klass.to_s, ivars_for(obj)])
        end
      end
    
      def load str
        type, klass, data = decode(str)
      
        type == PRIMITIVE ?
          load_primitive(klass, data) :
          load_user_defined_class(klass, data)
      end
      
    private
    
      def load_primitive _, data
        data
      end
      
      def load_user_defined_class(klass_name, data)
        UserDefinedLoader.load(klass_name, data)
      end
      
      def ivars_for obj
        returning Hash.new do |hash|
          obj.instance_variables.each do |variable|
            hash[variable] = Object.new("").write(obj.instance_variable_get(variable))
          end
        end
      end
    
      def encode tuple
        Base64.encode64(BERT.encode(tuple))
      end
      
      def decode str
        BERT.decode(Base64.decode64(str))
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
          eval(@klass_name)
        end
        
        def load_ivars obj
          ivars.each do |key, value|
            obj.instance_variable_set(key, value)
          end
        end
        
        def ivars
          returning Hash.new do |hash|
            @data.each do |key, oid|
              hash[key] = Object.new("").load_from_id(oid)
            end
          end
        end
      end
    end
  end
end