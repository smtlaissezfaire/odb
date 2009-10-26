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
      
      def load(str)
        Odb::Marshal.load(str)
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
      
      it "should be able to serialize & marshal a fixnum" do
        dump_and_load(1).should == 1
      end
      
      it "should be able to serialize & marshal the number 2" do
        dump_and_load(2).should == 2
      end

      it "should be able to serialize & marshal a bignum" do
        # >> 10_000_000_000_000_000_000.class
        # => Bignum
        
        num = 10_000_000_000_000_000_000
        
        dump_and_load(num).should == num
      end
      
      it "should be able to serialize & marshal a float" do
        dump_and_load(1.1).should == 1.1
      end
      
      it "should be able to serialize & marshal an array"
      
      it "should be able to serialize & marshal an set"
      
      it "should be able to serialize & marshal a hash"
    end
  end
end