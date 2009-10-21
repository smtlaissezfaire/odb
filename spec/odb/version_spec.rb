require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Odb do
  describe "VERSION" do
    it "should be at 0.0.0" do
      Odb::Version.string.should == "0.0.0"
    end
    
    it "should have major as 0" do
      Odb::Version.major.should == 0
    end
    
    it "should have minor as 0" do
      Odb::Version.minor.should == 0
    end
    
    it "should have tiny as 0" do
      Odb::Version.tiny.should == 0
    end
  end
end