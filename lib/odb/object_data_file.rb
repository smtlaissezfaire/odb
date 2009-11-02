module Odb
  class ObjectDataFile
    include FileHelpers

    class InvalidDataOffset < StandardError; end
    class DataNotFound      < StandardError; end

    def read(start, finish)
      if start >= finish
        raise(ObjectDataFile::InvalidDataOffset, "start value of data must be before the end value")
      end

      File.open(path.objects_file) do |f|
        if finish > File.size(path.objects_file)
          raise(DataNotFound, "Couldn't find data between offsets #{start}, #{finish}")
        end

        f.seek(start)
        f.read(finish - start)
      end
    end

    def write(obj)
      dumped_data = Marshal.dump(obj)
      last_byte   = size(path.objects_file)

      append_to_file(path.objects_file, dumped_data)

      [last_byte, last_byte + dumped_data.size]
    end

  private

    def size(file)
      File.size(file)
    end

    def path
      @path = Odb.path
    end
  end
end
