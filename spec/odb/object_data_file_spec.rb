require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

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
  end
end
