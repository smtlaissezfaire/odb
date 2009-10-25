require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe ObjectIdCalculator do
    before do
      ObjectIdCalculator.reset_object_hash!
    end
    
    it "should have nil as object id = 0" do
      ObjectIdCalculator.new(nil).object_id.should == 0
    end
    
    it "should use true as object id == 1" do
      ObjectIdCalculator.new(true).object_id.should == 1
    end
    
    it "should use false as object id == 2" do
      ObjectIdCalculator.new(false).object_id.should == 2
    end
    
    class UserDefined; end
    
    it "should have a user defined class instance starting at id: 100" do
      obj = UserDefined.new
      
      ObjectIdCalculator.new(obj).object_id.should == 100
    end
    
    it "should set the next object id to 101" do
      obj = UserDefined.new
      ObjectIdCalculator.new(obj)
      
      obj2 = UserDefined.new
      ObjectIdCalculator.new(obj2).object_id.should == 101
    end
    
    it "should reuse the same object id for the same object" do
      obj = UserDefined.new
      ObjectIdCalculator.new(obj)
      
      ObjectIdCalculator.new(obj).object_id.should == 100
    end
  end
end