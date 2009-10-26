require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'fakefs/safe'

module Odb
  describe ObjectIndex do
    before do
      FakeFS.activate!
      Odb.init ""
    end
    
    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end
    
    describe "ids" do
      before do
        @index = ObjectIndex.new("")
      end
      
      it "should be 1 with no lines in the file" do
        @index.next_id.should == 1
      end
      
      it "should have the next id based on the file length of the objects.idx file" do
        File.open("/odb/objects.idx", "w") { |f|
          f << "one\n"
          f << "two\n"
        }

        @index.next_id.should == 3
      end
    end
  end
end