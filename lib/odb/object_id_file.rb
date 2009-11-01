module Odb
  class ObjectIdFile
    include FileHelpers

    NEW_LINE = "\n"

    def write(object, start, finish)
      if object_id = ProcessIdMap[object]
        write_existing_object(object_id, start, finish)
      else
        write_new_object(object, start, finish)
      end
    end

  private

    def write_existing_object(object_id, start, finish)
      str = format_offsets(start, finish)
      str << NEW_LINE unless line_count(objects_index) == 1

      replace_line(objects_index, object_id, str)
    end

    def write_new_object(object, start, finish)
      str = ""
      str << NEW_LINE unless empty_file?(objects_index)
      str << format_offsets(start, finish)

      append_to_file(objects_index, str)
      write_to_process_map(object)
    end

    def write_to_process_map(object)
      ProcessIdMap[object] = line_count(objects_index)
    end

    def format_offsets(start, finish)
      "#{start},#{finish}"
    end

    def empty_file?(file)
      File.size(file) == 0
    end

    def objects_index
      path.objects_index
    end

    def path
      @path = Odb.path
    end
  end
end
