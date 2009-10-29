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

    # Fetch from the object file, starting with char +start+ to
    # char +finish+.  Counting starts at with char 1 (not char 0)
    # in the buffer
    def fetch(start, finish)
      start       = start - 1
      total_chars = finish - start
      
      f = File.open(objects_file)
      f.seek(start)
      f.read(total_chars)
    end

  private

    def objects_file
      Odb.path.objects_file
    end
  end
end
