require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe ObjectIdFile do
    before do
      FakeFS.activate!
      Odb.init "/"
      Odb.path = ""
    end
    
    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end

    describe "writing an object" do
      describe "writing a new object (one not in the process map)" do
        before do
          @obj     = Object.new
          @id_file = ObjectIdFile.new
        end

        it "should write the offsets given" do
          @id_file.write(@obj, 0, 2)

          File.read("/odb/objects.idx").should == "0,2"
        end

        it "should write the correct offsets" do
          @id_file.write(@obj, 3, 7)

          File.read("/odb/objects.idx").should == "3,7"
        end

        it "should append to the file on a new line" do
          File.open("/odb/objects.idx", "w") do |f|
            f << "1,2"
          end

          @id_file.write(@obj, 3, 4)

          File.read("/odb/objects.idx").should == "1,2\n3,4"
        end

        it "should store the line number the process map" do
          @id_file.write(@obj, 1, 2)

          Odb::ProcessIdMap[@obj].should == 1
        end

        it "should store the correct id in the process map (the line number written to the file)" do
          File.open("/odb/objects.idx", "w") do |f|
            f << "1,2"
          end

          @id_file.write(@obj, 1, 2)

          Odb::ProcessIdMap[@obj].should == 2
        end
      end

      describe "writing an existing object (one already in the process map" do
        before do
          @obj     = Object.new
          @id_file = ObjectIdFile.new

          File.open("/odb/objects.idx", "w") do |f|
            f << "1,3"
          end

          ProcessIdMap[@obj] = 1
        end

        it "should write the data to the file" do
          @id_file.write(@obj, 3, 7)

          File.read("/odb/objects.idx").should == "3,7"
        end

        it "should not delete other data" do
          other_object = Object.new
          @id_file.write(other_object, 1, 2)

          @id_file.write(@obj, 3, 4)

          File.read("/odb/objects.idx").should == "3,4\n1,2"
        end

        it "should append the newline even when another object is not in the process map" do
          File.open("/odb/objects.idx", "a") do |f|
            f << "\n4,5"
          end

          @id_file.write(@obj, 6,7)

          File.read("/odb/objects.idx").should == "6,7\n4,5"
        end

        it "should not append \n to the last entry" do
          new_obj = Object.new

          @id_file.write(new_obj, 4, 5)

          File.read("/odb/objects.idx").should == "1,3\n4,5"
        end
      end

      describe "getting offsets from an id (line number)" do
        before do
          @id_file = ObjectIdFile.new
        end

        it "should raise an error if the file is empty" do
          lambda {
            @id_file.read(0)
          }.should raise_error(RecordNotFound, "Couldn't find odb object id: 0")
        end

        it "should use the correct id in the error" do
          lambda {
            @id_file.read(1)
          }.should raise_error(RecordNotFound, "Couldn't find odb object id: 1")
        end

        it "should return a tuple from the file" do
          File.open("/odb/objects.idx", "w") do |f|
            f << "1,2"
          end

          @id_file.read(0).should == [1,2]
        end

        it "should return the correct values from the first line" do
          File.open("/odb/objects.idx", "w") do |f|
            f << "3,4"
          end

          @id_file.read(0).should == [3, 4]
        end

        it "should only read the first line when the first line is specified" do
          File.open("/odb/objects.idx", "w") do |f|
            f << "1,2\n3,4"
          end

          @id_file.read(0).should == [1,2]
        end

        it "should use the correct line" do
          File.open("/odb/objects.idx", "w") do |f|
            f << "1,2\n3,4"
          end

          @id_file.read(1).should == [3, 4]
        end

        it "should raise an error if there is no id in the file" do
          File.open("/odb/objects.idx", "w") do |f|
            f << "1,2\n3,4"
          end

          lambda {
            @id_file.read(2)
          }.should raise_error(RecordNotFound, "Couldn't find odb object id: 2")
        end

        it "should raise the correct error if there is no id in the file" do
          File.open("/odb/objects.idx", "w") do |f|
            f << "1,2\n3,4"
          end

          lambda {
            @id_file.read(3)
          }.should raise_error(RecordNotFound, "Couldn't find odb object id: 3")
        end
      end
    end
  end
end
