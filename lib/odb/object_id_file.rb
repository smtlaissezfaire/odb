module Odb
  class ObjectIdFile
    def write(object, start, finish)
      File.open(path.objects_index, "a") do |f|
        f << "\n" if !empty_file?(path.objects_index)
        f << "#{start},#{finish}"
      end

      line_num = File.readlines(path.objects_index).size

      ProcessIdMap[object] = line_num
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
