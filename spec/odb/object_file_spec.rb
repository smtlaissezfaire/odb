require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe ObjectFile do
    before do
      FakeFS.activate!
      Odb.init "/"
      Odb.path = "/"

      @file = ObjectFile.new
    end
    
    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end

    describe "writing" do
      before do
        @obj = ::Object.new
      end

      it "should add the marshalled content to the file" do
        Marshal.stub!(:dump).and_return "some_output"

        @file.write(@obj)

        File.read("/odb/objects").should == "some_output"
      end

      it "should add it to the end of the file" do
        File.open("/odb/objects", "w") { |f| f << "other_content\t" }

        Marshal.stub!(:dump).and_return "some_output"

        @file.write(@obj)

        File.read("/odb/objects").should == "other_content\tsome_output"
      end
    end

    describe "finding based on the start and end markers" do
      before do
        @obj = ::Object.new
      end

      it "should be able to fetch the whole content of the buffer" do
        str = "123456789"

        File.open("/odb/objects", "w") { |f| f << "123456789" }

        @file.fetch(1, 9).should == str
      end
      
      it "should correspond to the real buffer" do
        File.open("/odb/objects", "w") { |f| f << "one" }
      
        @file.fetch(1, 3).should == "one"
      end
      
      it "should only send back the parts of the buffer requested" do
        File.open("/odb/objects", "w") { |f| f << "foobar" }
      
        @file.fetch(2, 4).should == "oob"
      end
    end
  end
end
