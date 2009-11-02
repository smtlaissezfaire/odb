require "spec_helper"

module Odb
  describe Path do
    describe "file_system_path" do
      it "should be the path given to the constructor" do
        Path.new("/foo/bar").file_system_path.should == "/foo/bar"
      end
      
      it "should expand the path" do
        pending "FIXME: This is a bug in fakefs" do
          Path.new(".").file_system_path.should == File.expand_path(".")
        end
      end
    end
    
    describe "==" do
      it "should be true with the same path" do
        Path.new("/").should == Path.new("/")
      end
      
      it "should be false if a different path" do
        Path.new("/foo").should_not == Path.new("/")
      end
      
      it "should be false if the object being compared does not respond to file_system_path" do
        Path.new("/").should_not == Object.new
      end
    end
  end
end