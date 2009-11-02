require "spec_helper"

module Odb
  describe ObjectIndexFile do
    before do
      FakeFS.activate!
      Odb.init "/"
      Odb.path = "/"
    end
    
    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end

    describe "adding" do
      before do
        @index = ObjectIndexFile.new
      end

      it "should add the value to the file" do
        @index.add(10)
        File.read("/odb/objects.idx").should == "10\n"
      end

      it "should add it to the end of the file" do
        File.open("/odb/objects.idx", "w") { |f| f << "something\n" }

        @index.add(10)
        File.read("/odb/objects.idx").should == "something\n10\n"
      end

      it "should add multiple values, seperated by commas" do
        @index.add(10, 20)

        File.read("/odb/objects.idx").should == "10,20\n"
      end
    end

    describe "replacing / updating" do
      before do
        @index = ObjectIndexFile.new
      end

      it "should update the line based on the object id + value" do
        File.open("/odb/objects.idx", "w") { |f| f << "one\n" }

        @index.replace(1, "two")
        File.read("/odb/objects.idx").should == "two\n"
      end

      it "should replace with several values" do
        File.open("/odb/objects.idx", "w") { |f| f << "one\n" }

        @index.replace(1, 2, 3)
        File.read("/odb/objects.idx").should == "2,3\n"
      end

      context "when it can't find the line" do
        it "should raise"
      end
    end
  end
end
