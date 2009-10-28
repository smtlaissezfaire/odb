require 'facets/kernel/returning'

module Odb
  class Object
    def initialize odb_path=""
      @path = Path.new(odb_path)
    end
    
    def current_id
      line_count(@path.objects_index)
    end
    
    def next_id
      current_id + 1
    end
    
    def write obj
      if tracked_object?(obj)
        returning object_id(obj) do |oid|
          offset = write_to_object_file(Marshal.dump(obj))
          replace_in_index_file(oid, offset)
        end
      else
        offset = write_to_object_file(Marshal.dump(obj))
        oid = write_to_index_file(offset)
        store_in_process_id_map(obj, oid)
        oid
      end
    end
    
    def load_from_id oid
      offset = File.read(@path.objects_index).split("\n")[oid - 1]
      marshalled_string = File.read(@path.objects_file).split("\n")[offset.to_i - 1]
      
      Marshal.load(marshalled_string)
    end
    
  private
  
    def object_id obj
      ProcessIdMap[obj.object_id]
    end
  
    def store_in_process_id_map obj, object_id
      ProcessIdMap[obj.object_id] = object_id
    end
  
    def tracked_object? obj
      ProcessIdMap.has_key?(obj.object_id)
    end
  
    def write_to_object_file str
      File.open(@path.objects_file, "a") do |f|
        f << str
      end
      
      line_count(@path.objects_file)
    end
    
    def replace_in_index_file object_id, offset
      txt = ""
      
      File.readlines(@path.objects_index).each_with_index do |line, index|
        if index == object_id - 1
          txt << "#{offset}\n"
        else
          txt << line
        end
      end
      
      File.open(@path.objects_index, "w") { |f| f << txt }
    end
  
    def write_to_index_file offset
      File.open(@path.objects_index, "a") do |f|
        f << "#{offset}\n"
      end
      
      line_count(@path.objects_index)
    end
  
    def line_count file
      lines = 0
      
      File.readlines(file).each do |_|
        lines += 1
      end
      
      lines
    end
  end
end