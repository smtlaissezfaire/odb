module Odb
  class ObjectFile
    include FileHelpers

    def write(obj)
      append_to_file objects_file, Marshal.dump(obj)
      line_count     objects_file
    end

    def [](offset)
      line_at(objects_file, offset)
    end

  private

    def objects_file
      Odb.path.objects_file
    end
  end
end
