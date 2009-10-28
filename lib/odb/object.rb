module Odb
  class Object
    include FileHelpers
    
    def current_id
      index.current_id
    end
    
    def next_id
      current_id + 1
    end
    
    def write obj
      offset = index.write(obj)
      
      if tracked_object? obj
        oid = object_id(obj)
        index.replace(oid, offset)
      else
        oid = index.append(offset)
        store_in_process_id_map(obj, oid)
      end
      
      oid
    end
    
    def load_from_id oid
      offset            = index[oid]
      marshalled_string = objects[offset]
      
      Marshal.load(marshalled_string)
    end
    
  private

    def index
      @index_file ||= ObjectIndexFile.new
    end

    def objects
      @objects ||= ObjectFile.new
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
  end
end
