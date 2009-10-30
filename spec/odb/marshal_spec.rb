require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe Marshal do
    before do
      FakeFS.activate!
      Odb.init "/"
      Odb.path = "/"
    end
    
    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end
    
    describe "serialization" do
      def dump_and_load obj
        load(dump(obj))
      end
      
      def dump obj
        Odb::Marshal.dump(obj)
      end
      
      def load str
        Odb::Marshal.load(str)
      end
      
      it "should be able to serialize an object" do
        obj = ::Object.new
        dump_and_load(obj).class.should == Object
      end
      
      class UserDefined
      end
      
      it "should be able to serialize & marshal a user defined object" do
        dump_and_load(UserDefined.new).class.should == UserDefined
      end
      
      it "should be able to serialize & marshal a user defined object with an ivar" do
        obj = UserDefined.new
        obj.instance_variable_set("@foo", true)
        
        dump_and_load(obj).instance_variable_get("@foo").should == true
      end
      
      it "should set the correct value" do
        obj = UserDefined.new
        obj.instance_variable_set("@foo", false)
        
        dump_and_load(obj).instance_variable_get("@foo").should == false
      end
      
      it "should set the correct ivar by name" do
        obj = UserDefined.new
        obj.instance_variable_set("@bar", true)
        
        dump_and_load(obj).instance_variable_get("@bar").should == true
      end
      
      it "should be able to serialize & marshal a user defined object with multiple ivars" do
        obj = UserDefined.new
        obj.instance_variable_set("@foo", true)
        obj.instance_variable_set("@bar", false)

        loaded_obj = dump_and_load(obj)
        loaded_obj.instance_variable_get("@foo").should == true
        loaded_obj.instance_variable_get("@bar").should == false
      end
      
      it "should use references by object ids with ivar values (should be able to serialize user-created references)" do
        obj1 = UserDefined.new
        oid  = Odb::Object.new.write(obj1)
        
        obj2 = UserDefined.new
        obj2.instance_variable_set "@reference", obj1

        loaded_obj2 = dump_and_load(obj2)
        loaded_obj2.instance_variable_get("@reference").should be_a_kind_of(UserDefined)
      end
      
      class UserDefinedWithInitValue
        def initialize val1
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
        pending 'fixme'
        
        num = 10_000_000_000_000_000_000
        
        dump_and_load(num).should == num
      end
      
      it "should be able to serialize & marshal a float" do
        dump_and_load(1.1).should == 1.1
      end
      
      it "should be able to serialize & marshal a symbol" do
        dump_and_load(:foo).should == :foo
      end
      
      it "should be able to serialize a regex" do
        regex = /foo|bar/
        
        dump_and_load(regex).should == regex
      end
      
      it "should be able to serialize & marshal a time object" do
        t = Time.now
        
        dump_and_load(t).should == t
      end
      
      it "should be able to serialize & marshal a date object" do
        pending

        d = Date.new
        dump_and_load(d).should == d
      end
      
      it "should be able to serialize & marshal a datetime object"
      
      it "should be able to serialize & marshal an array"
      
      it "should be able to serialize & marshal an set"
      
      it "should be able to serialize & marshal a hash"
    end
  end
end