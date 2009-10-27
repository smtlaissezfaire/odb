module Odb
  class Object
    def initialize(odb_path)
      @path = Path.new(odb_path)
    end
    
    def current_id
      line_count(@path.objects_index)
    end
    
    def next_id
      current_id + 1
    end
    
  private
  
    def line_count(file)
      lines = 0
      
      File.read(file).each_line do |_|
        lines += 1
      end
      
      lines
    end
  end
end