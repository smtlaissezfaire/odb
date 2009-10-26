require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe Marshal do
    describe "serialization" do
      def dump_and_load(obj)
        load(dump(obj))
      end
      
      def dump(obj)
        Odb::Marshal.dump(obj)
      end
      
      def load(obj)
        Odb::Marshal.load(obj)
      end
      
      it "should be able to serialize an object" do
        obj = Object.new
        
        dump_and_load(obj).class.should == Object
      end
      
      class UserDefined
      end
      
      it "should be able to serialize & marshal a user defined object" do
        dump_and_load(UserDefined.new).class.should == UserDefined
      end
      
      it "should be able to serialize & marshal a user defined object with an ivar"

      it "should be able to serialize & marshal a user defined object with multiple ivars"
      
      class UserDefinedWithInitValue
        def initialize(val1)
        end
      end
      
      it "should be able to serialize & marshal a user defined object which takes a value in the initialize method" do
        obj = UserDefinedWithInitValue.new("whatever")
        
        dump_and_load(obj).class.should == UserDefinedWithInitValue
      end
      
      it "should be able to serialize & marshal a nil" do
        dump_and_load(nil).should equal(nil)
      end
      
      it "should be able to serialize & marshal a false" do
        dump_and_load(false).should equal(false)
      end
      
      it "should be able to serialize & marshal a true" do
        dump_and_load(true).should equal(true)
      end
      
      it "should be able to serialize & marshal a fixnum"

      it "should be able to serialize & marshal a bignum"
      
      it "should be able to serialize & marshal a float"
      
      it "should be able to serialize & marshal an array"
      
      it "should be able to serialize & marshal an set"
      
      it "should be able to serialize & marshal a hash"
    end
  end
end