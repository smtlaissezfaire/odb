require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Odb do
  describe "root" do
    it "should be empty initially" do
      Odb.root.should be_nil
    end
    
    it "should be assignable" do
      obj = Object.new
      
      Odb.root = obj
      Odb.root.should == obj
    end
  end
end