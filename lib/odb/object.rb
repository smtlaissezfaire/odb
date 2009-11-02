module Odb
  class Object
    include FileHelpers

    def self.write(obj)
      new.write(obj)
    end

    def self.read(object_id)
      new.read(object_id)
    end

    def write obj
      index.write(obj, *object_data_file.write(obj))
      process_ids[obj]
    end

    def read oid
      Marshal.load(object_data_file.read(*index.read(oid)))
    end

  private

    def index
      @index_file ||= ObjectIdFile.new
    end

    def object_data_file
      @objects ||= ObjectDataFile.new
    end

    def process_ids
      ProcessIdMap
    end
  end
end
