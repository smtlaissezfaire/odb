module Odb
  module Serialize
    def self.included(klass)
      StartupHooks.hook_into(klass)
    end
    
    class StartupHooks
      def self.hook_into(klass)
        new(klass).hook!
      end
      
      def initialize(klass)
        @klass = klass
      end
      
      def hook!
        FileUtils.mkdir_p Odb.database_path
        FileUtils.touch File.join(Odb.database_path, database_name)
      end
      
    private
    
      def database_name
        if @klass.respond_to?(:_database_name)
          @klass._database_name
        else
          @klass.to_s
        end
      end
    end
    # def dump
    #   Marshal.dump(self)
    # end
    # 
    # class Committer
    #   def self.commit(obj)
    #     new(obj).commit
    #   end
    #   
    #   def initialize(obj)
    #     @obj = obj
    #   end
    #   
    #   def commit
    #     FileUtils.touch(File.join(Odb.database_path, @obj.class.to_s))
    #   end
    # end
    # 
    # def commit
    #   Committer.commit(self)
    # end
  end
end