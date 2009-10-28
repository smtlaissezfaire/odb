module Odb
  module FileHelpers
    def file_exists? *args
      File.exists? join(*args)
    end

    def mkdir *args
      Dir.mkdir join(*args)
    end

    def touch *args
      FileUtils.touch join(*args)
    end

    def join *args
      File.join(*args)
    end
  end
end