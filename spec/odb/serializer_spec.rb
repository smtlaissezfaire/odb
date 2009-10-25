require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe Serializer do
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
      
      class UserDefined; end
      
      it "should serialize a user defined object" do
        obj = UserDefined.new
        Serializer.dump(obj).should == "class:Odb::UserDefined"
      end
      
      class UserDefined2; end
      
      it "should use the correct class name" do
        obj = UserDefined2.new
        
        Serializer.dump(obj).should == "class:Odb::UserDefined2"
      end
      
      def object_id_for(obj)
        ObjectIdCalculator.new(obj).object_id
      end
      
      it "should serialize an ivar, with a reference to an object id" do
        obj = UserDefined.new
        obj.instance_variable_set("@foo", true)
        
        Serializer.dump(obj).should == "class:Odb::UserDefined,@foo:#{object_id_for(true)}"
      end
      
      it "should serialize an ivar, with a reference to an object id" do
        obj = UserDefined.new
        obj.instance_variable_set("@foo", false)
        
        Serializer.dump(obj).should == "class:Odb::UserDefined,@foo:#{object_id_for(false)}"
      end
      
      it "should serialize the correct ivar" do
        obj = UserDefined.new
        obj.instance_variable_set("@bar", true)
        
        Serializer.dump(obj).should == "class:Odb::UserDefined,@bar:#{object_id_for(true)}"
      end
      
      it "should serialize multiple ivars" do
        obj = UserDefined.new
        obj.instance_variable_set("@foo", true)
        obj.instance_variable_set("@bar", false)
        
        Serializer.dump(obj).should include(",@bar:#{object_id_for(false)}")
        Serializer.dump(obj).should include(",@foo:#{object_id_for(true)}")
      end
      
      it "should be able to serialize a fixnum" do
        Serializer.dump(1).should == Marshal.dump(1)
      end
      
      it "should be able to serialize a bignum" do
        bignum = 10_000_000_000_000_000_000
        
        Serializer.dump(bignum).should == Marshal.dump(bignum)
      end
      
      it "should be able to serialize a floating point number" do
        float = 1.2
        
        Serializer.dump(float).should == Marshal.dump(float)
      end
      
      it "should be able to serialize an array"
      
      it "should be able to serialize a hash"
      
      it "should be able to serialize a struct"
      
      it "should raise when serializing a file handle"
    end
  end
end