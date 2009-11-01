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
        if finish > f.size
          raise(DataNotFound, "Couldn't find data between offsets #{start}, #{finish}")
        end

        f.seek(start)
        f.read(finish - start)
      end
    end

    def write(obj)
      size_before_and_after path.objects_file do |file|
        append_to_file(file, Marshal.dump(obj))
      end
    end

  private

    def size_before_and_after(file)
      before = size(file)
      yield file
      after = size(file)

      [before, after]
    end

    def size(file)
      File.size(file)
    end

    def path
      @path = Odb.path
    end
  end
end
