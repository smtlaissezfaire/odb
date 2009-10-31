module Odb
  class ObjectIdFile
    include FileHelpers

    def write(object, start, finish)
      if object_id = ProcessIdMap[object]
        str = "#{start},#{finish}"
        str << "\n" if ProcessIdMap.size != 1

        replace_line path.objects_index, object_id, str
      else
        File.open(path.objects_index, "a") do |f|
          f << "\n" if !empty_file?(path.objects_index)
          f << "#{start},#{finish}"
        end
   
        line_num = File.readlines(path.objects_index).size
   
        ProcessIdMap[object] = line_num
      end
    end

  private

    def empty_file?(file)
      File.size(file) == 0
    end

    def path
      @path = Odb.path
    end
  end
end
