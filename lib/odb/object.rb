module Odb
  class Object
    include FileHelpers
    
    def current_id
      line_count objects_index
    end
    
    def next_id
      current_id + 1
    end
    
    def write obj
      offset = write_to_object_file(obj)
      
      if tracked_object? obj
        oid = object_id(obj)
        replace_in_index_file(oid, offset)
      else
        oid = write_to_index_file(offset)
        store_in_process_id_map(obj, oid)
      end
      
      oid
    end
    
    def load_from_id oid
      offset            = line_at(objects_index, oid).to_i
      marshalled_string = line_at(objects_file,  offset)
      
      Marshal.load(marshalled_string)
    end
    
  private
  
    def path
      Odb.path
    end
    
    def objects_index
      path.objects_index
    end
    
    def objects_file
      path.objects_file
    end
  
    def object_id obj
      ProcessIdMap.get_oid(obj)
    end
  
    def store_in_process_id_map obj, object_id
      ProcessIdMap.set_oid(obj, object_id)
    end
  
    def tracked_object? obj
      ProcessIdMap.tracked_object?(obj)
    end
  
    def write_to_object_file obj
      append_to_file objects_file, Marshal.dump(obj)
      line_count     objects_file
    end
    
    def replace_in_index_file object_id, offset
      replace_line objects_index, object_id, "#{offset}\n"
    end
  
    def write_to_index_file offset
      append_to_file objects_index, "#{offset}\n"
      line_count     objects_index
    end
  end
end