require "spec_helper"

module Odb
  describe ObjectDataFile do
    before do
      FakeFS.activate!
      Odb.init
      Odb.path = ""
    end

    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end

    describe "write" do
      before do
        @obj = ::Object.new
        @data_file = ObjectDataFile.new

        Marshal.stub!(:dump).and_return "content"
      end

      it "should marshal the data file" do
        Marshal.should_receive(:dump).with(@obj).and_return "foo"
        @data_file.write(@obj)
      end

      it "should dump the data to the objects file" do
        Marshal.stub!(:dump).and_return "content"

        @data_file.write(@obj)

        File.read("/odb/objects").should == "content"
      end

      it "should dump the correct data to the objects file" do
        Marshal.stub!(:dump).and_return "foo"

        @data_file.write(@obj)

        File.read("/odb/objects").should == "foo"
      end

      it "should dump to the correct data file" do
        Dir.mkdir("/foo")
        Dir.mkdir("/foo/bar")
        Dir.mkdir("/foo/bar/odb")
        FileUtils.touch("/foo/bar/odb/objects")

        Odb.path = "/foo/bar"
        Marshal.stub!(:dump).and_return "content"

        @data_file.write(@obj)

        File.read("/foo/bar/odb/objects").should == "content"
      end

      it "should not wipe out the old data in the file" do
        File.open("/odb/objects", "w") do |f|
          f << "foo"
        end

        Marshal.stub!(:dump).and_return "bar"

        @data_file.write(@obj)

        File.read("/odb/objects").should == "foobar"
      end

      it "should return an array with the length of the data" do
        Marshal.stub!(:dump).and_return("1")

        @data_file.write(@obj).should == [0, 1]
      end

      it "should use the correct values for the length of the data" do
        Marshal.stub!(:dump).and_return "12"

        @data_file.write(@obj).should == [0, 2]
      end

      it "should return the correct offsets in the file" do
        File.open("/odb/objects", "w") do |f|
          f << "123"
        end

        Marshal.stub!(:dump).and_return "456"

        @data_file.write(@obj).should == [3, 6]
      end
    end

    describe "reading" do
      before do
        @data_file = ObjectDataFile.new
      end

      it "should be able to get data from the offsets 0,1" do
        File.open("/odb/objects", "w") do |f|
          f << "a"
        end

        @data_file.read(0, 1).should == "a"
      end

      it "should read the correct data from offsets 0,1" do
        File.open("/odb/objects", "w") do |f|
          f << "b"
        end

        @data_file.read(0, 1).should == "b"
      end

      it "should only read the data specified in the offset" do
        File.open("/odb/objects", "w") do |f|
          f << "ab"
        end

        @data_file.read(0, 1).should == "a"
      end

      it "should use the correct end offset" do
        File.open("/odb/objects", "w") do |f|
          f << "abc"
        end

        @data_file.read(0, 3).should == "abc"
      end

      it "should use the correct start offset" do
        File.open("/odb/objects", "w") do |f|
          f << "abc"
        end

        @data_file.read(1, 3).should == "bc"
      end

      it "should raise an error if it can't find the data" do
        lambda {
          @data_file.read(0, 1)
        }.should raise_error(ObjectDataFile::DataNotFound, "Couldn't find data between offsets 0, 1")
      end

      it "should use the correct offsets" do
        lambda {
          @data_file.read(1, 2)
        }.should raise_error(ObjectDataFile::DataNotFound, "Couldn't find data between offsets 1, 2")
      end

      it "should raise if it can't find the data" do
        File.open("/odb/objects", "w") do |f|
          f << "abc"
        end

        lambda {
          @data_file.read(5, 7)
        }.should raise_error(ObjectDataFile::DataNotFound, "Couldn't find data between offsets 5, 7")
      end

      it "should use the correct numbers in the error message" do
        File.open("/odb/objects", "w") do |f|
          f << "abc"
        end

        lambda {
          @data_file.read(7, 10)
        }.should raise_error(ObjectDataFile::DataNotFound, "Couldn't find data between offsets 7, 10")
      end

      it "should raise an error when given a start value greater than an end value" do
        lambda {
          @data_file.read(10, 7)
        }.should raise_error(ObjectDataFile::InvalidDataOffset, "start value of data must be before the end value")
      end

      it "should raise an error if the start value is equal to the end value" do
        lambda {
          @data_file.read(7, 7)
        }.should raise_error(ObjectDataFile::InvalidDataOffset, "start value of data must be before the end value")
      end
    end
  end
end
