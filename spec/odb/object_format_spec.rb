require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe ObjectFormat do
    describe "primitives" do
      before do
        @primitive = ObjectFormat::Primitive.new
      end
      
      it "should be able to set a nil" do
        @primitive.primitive = ObjectFormat::Primitive::Primitives::NIL
        @primitive.primitive.should == ObjectFormat::Primitive::Primitives::NIL
      end
      
      it "should be able to set a false" do
        @primitive.primitive = ObjectFormat::Primitive::Primitives::FALSE
        @primitive.primitive.should == ObjectFormat::Primitive::Primitives::FALSE
      end
      
      it "should be able to set a true" do
        @primitive.primitive = ObjectFormat::Primitive::Primitives::TRUE
        @primitive.primitive.should == ObjectFormat::Primitive::Primitives::TRUE
      end
      
      it "should require the primitive field" do
        @primitive.primitive = ObjectFormat::Primitive::Primitives::TRUE
        @primitive.should be_initialized
        
        @primitive.primitive = nil
        @primitive.should_not be_initialized
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
      end
      
      describe "data" do
        it "should be valid as a user defined type" do
          obj = ObjectFormat::UserDefinedObject.new
        
          @format.data = obj
          @format.data.should == obj
        end
      
        it "should be valid as a primitive" do
          obj = ObjectFormat::Primitive.new

          @format.primitive = obj
          @format.primitive.should == obj
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
    end
  end
end