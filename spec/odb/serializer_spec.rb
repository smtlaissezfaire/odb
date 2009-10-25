require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe Serializer do
    class UserDefined; end
    
    describe "serializing (with dump)" do
      it "should serialize a nil by marshaling it" do
        Serializer.dump(nil).should == Marshal.dump(nil)
      end
      
      it "should serialize a false by marshaling it" do
        Serializer.dump(false).should == Marshal.dump(false)
      end
      
      it "should serialize a true by marshaling it" do
        Serializer.dump(true).should == Marshal.dump(true)
      end
      
      it "should serialize a user defined object" do
        obj = UserDefined.new
        Serializer.dump(obj).should == "class:UserDefined"
      end
      
      it "should serialize an ivar, with a reference to an object id" do
        pending 'todo'
        obj = UserDefined.new
        obj.instance_variable_set("@foo", true)
        
        Serializer.new(obj).should == "class:UserDefined,@foo:<obj-id>"
      end
      
      it "should be able to serialize a fixnum"
      
      it "should be able to serialize a bignum"
      
      it "should be able to serialize a floating point number"
      
      it "should be able to serialize an array"
      
      it "should be able to serialize a hash"
      
      it "should be able to serialize a struct"
      
      it "should raise when serializing a file handle"
    end
  end
end