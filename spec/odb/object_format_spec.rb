require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe ObjectFormat do
    describe "primitives" do
      before do
        @format = ObjectFormat.new
      end
      
      it "should be able to set a nil" do
        @format.primitive = ObjectFormat::Primitive::NIL
        @format.primitive.should == ObjectFormat::Primitive::NIL
      end
      
      it "should be able to set a false" do
        @format.primitive = ObjectFormat::Primitive::FALSE
        @format.primitive.should == ObjectFormat::Primitive::FALSE
      end
      
      it "should be able to set a true" do
        @format.primitive = ObjectFormat::Primitive::TRUE
        @format.primitive.should == ObjectFormat::Primitive::TRUE
      end
    end
    
    describe "user defined object" do
      before do
        @object = ObjectFormat::UserDefinedObject.new
      end
      
      it "should be able to assign the class" do
        @object.class_name = "Foo::Bar"
        @object.class_name.should == "Foo::Bar"
      end
      
      it "should have an empty list of ivars by default" do
        @object.ivars.should == []
      end
      
      it "should be able to assign an ivar" do
        ivar = ObjectFormat::UserDefinedObject::InstanceVariable.new
        
        @object.ivars << ivar
        @object.ivars.should == [ivar]
      end
      
      describe "required" do
        before do
          @object.class_name = "Foo"
        end
        
        it "should be fully initialized with a name" do
          @object.should be_initialized
        end
        
        it "should not be initialized without a name" do
          @object.class_name = nil
          @object.should_not be_initialized
        end
      end
      
      describe "Instance Variable" do
        before do
          @ivar = ObjectFormat::UserDefinedObject::InstanceVariable.new
        end
        
        it "should have a name (without the '@' sign)" do
          @ivar.name = "foo"
          @ivar.name.should == "foo"
        end
        
        it "should have an object id value" do
          @ivar.object_id = 2342
          @ivar.object_id.should == 2342
        end
        
        describe "required fields" do
          before do
            @ivar.name = "foo"
            @ivar.object_id = 123
          end
          
          it "should be initialized with the object id & name" do
            @ivar.should be_initialized
          end
          
          it "should not be initialized when missing the name" do
            @ivar.name = nil
            @ivar.should_not be_initialized
          end
          
          it "should not be initialized when missing the object id" do
            @ivar.object_id = nil
            @ivar.should_not be_initialized
          end
        end
      end
    end
    
    describe "basic attributes" do
      before do
        @format = ObjectFormat.new
        @format.object_id = 1
        @format.is_primitive = true
      end
      
      describe "data" do
        it "should be valid as a user defined type" do
          obj = ObjectFormat::UserDefinedObject.new
        
          @format.data = obj
          @format.data.should == obj
        end
      end
      
      it "should have an object id" do
        @format.object_id = 10
        @format.object_id.should == 10
      end
      
      it "should require an object id" do
        @format.object_id = 10
        @format.should be_initialized
        
        @format.object_id = nil
        @format.should_not be_initialized
      end
      
      it "should require the boolean 'is_primitive' to be set" do
        @format.is_primitive = false
        @format.should be_initialized
        
        @format.is_primitive = true
        @format.should be_initialized
        
        @format.is_primitive = nil
        @format.should_not be_initialized
      end
    end
  end
end