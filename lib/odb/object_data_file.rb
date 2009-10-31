module Odb
  class ObjectDataFile
    include FileHelpers

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
