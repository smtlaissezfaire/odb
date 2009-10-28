module Odb
  class ObjectIndexFile
    include FileHelpers

    def current_id
      line_count objects_index
    end

    def add(*values)
      append_to_file objects_index, "#{values.join(",")}\n"
      line_count     objects_index
    end

    def replace(object_id, *values)
      replace_line objects_index, object_id, "#{values.join(",")}\n"
    end

    def [](oid)
      line_at(objects_index, oid).to_i
    end

  private

    def objects_file
      path.objects_file
    end

    def objects_index
      path.objects_index
    end

    def path
      Odb.path
    end
  end
end
