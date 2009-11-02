require "spec_helper"

describe Odb do
  describe "path" do
    before do
      Odb.path = nil
    end
    
    it "should be nil if none is set" do
      Odb.path.should be_nil
    end
    
    it "should set it to nil when set to nil (not to a path object)" do
      Odb.path = nil
      Odb.path.should be_nil
    end
    
    it "should set it to nil when passing false" do
      Odb.path = false
      Odb.path.should be_nil
    end
    
    it "should be able to set the path, and store it as a path object" do
      Odb.path = "/foo/bar"
      Odb.path.should == Odb::Path.new("/foo/bar")
    end
  end
end