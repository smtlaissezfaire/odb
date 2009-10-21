module Odb
  module Serialize
    def self.included(klass)
      klass.extend ClassMethods
    end
    
    def commit
      Committer.commit(self)
    end
    
    module PathName
      def path_name(klass)
        File.join(Odb.database_path, database_name(klass))
      end
      
    private
    
      def database_name(obj_klass)
        obj_klass.respond_to?(:_database_name) ?
          obj_klass._database_name :
          obj_klass.to_s
      end
    end
    
    module ClassMethods
      include PathName
      
      def serialize
        StartupHooks.hook_into(self)
      end
      
      def all
        Marshal.load File.read(path_name(self))
      rescue ArgumentError
        []
      end
      
      def find_by_attribute(attribute_name, value)
        all.select { |row| row.send(attribute_name) == value }
      end
      
      def find_first_by_attribute(attribute_name, value)
        all.detect { |row| row.__send__(attribute_name) == value }
      end
    end
    
    class StartupHooks
      include PathName
      
      def self.hook_into(klass)
        new(klass).hook!
      end
      
      def initialize(klass)
        @klass = klass
      end
      
      def hook!
        FileUtils.mkdir_p Odb.database_path
        FileUtils.touch   path_name(@klass)
      end
    end
    
    class Committer
      include PathName
      
      def self.commit(obj)
        new(obj).commit
      end
      
      def initialize(obj)
        @obj = obj
      end
      
      def commit
        all = @obj.class.all
        all << @obj if !all.include?(@obj)
        
        dump_to_file(Marshal.dump(all))
      end
      
    private
      
      def dump_to_file(str)
        File.open(file_path, "w") { |f| f << str }
      end
      
      def file_path
        path_name @obj.class
      end
    end
  end
end