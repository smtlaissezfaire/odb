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
    
    def lines_of(file)
      File.readlines(file)
    end
    
    def line_count file
      lines_of(file).size
    end
    
    def line_at(file, line_num)
      lines_of(file)[line_num - 1]
    end
    
    def replace_line(file, line_number, replacement)
      txt = ""
      
      File.readlines(file).each_with_index do |line, index|
        if index == line_number
          txt << replacement
        else
          txt << line
        end
      end
      
      File.open(file, "w") { |f| f << txt }
    end
    
    def append_to_file(file, contents)
      File.open(file, "a") { |f| f << contents }
    end
  end
end