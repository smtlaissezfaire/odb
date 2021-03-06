require "spec_helper"

module Odb
  module Proxy
    describe Array do
      before do
        FakeFS.activate!
        Odb.init "/"
        Odb.path = "/"
      end
      after do
        FakeFS::FileSystem.clear
        FakeFS.deactivate!
      end

      describe "empty?" do
        before do
          @array = Odb::Proxy::Array.new
        end

        it "should be true when first instantiated (with no values)" do
          @array.should be_empty
        end

        it "should be false if it has a value" do
          array = Odb::Proxy::Array.new(1)
          array.should_not be_empty
        end
      end

      describe "accessing elements" do
        before do
          @obj       = ::Object.new
          @object_id = Odb::Object.write(@obj)

          @array = Odb::Proxy::Array.new
        end

        it "should be able to access element 0" do
          @array << @object_id
          @array[0].should be_a_kind_of(::Object)
        end

        it "should be able to access an element @ 1" do
          obj2 = "foo"
          oid = Odb::Object.write(obj2)

          @array << @object_id
          @array << oid

          @array[1].should == obj2
        end
      end

      describe "each" do
        before do
          @obj1 = "foobar"
          @obj2 = "baz"

          @object_id_one = Odb::Object.write(@obj1)
          @object_id_two = Odb::Object.write(@obj2)

          @array = Odb::Proxy::Array.new([@object_id_one, @object_id_two])
        end

        it "should have all the objects" do
          collection = []

          @array.each do |x|
            collection << x
          end

          collection.should == [@obj1, @obj2]
        end
      end

      describe "to_a" do
        before do
          @obj1 = "foobar"
          @obj2 = "baz"

          @object_id_one = Odb::Object.write(@obj1)
          @object_id_two = Odb::Object.write(@obj2)

          @array = Odb::Proxy::Array.new([@object_id_one, @object_id_two])
        end

        it "should return all the objects, loaded" do
          @array.to_a.should == [@obj1, @obj2]
        end
      end

      describe "first & last" do
        before do
          @obj1 = "foobar"
          @obj2 = "baz"

          @object_id_one = Odb::Object.write(@obj1)
          @object_id_two = Odb::Object.write(@obj2)

          @array = Odb::Proxy::Array.new([@object_id_one, @object_id_two])
        end

        it "should return the first element in the set" do
          @array.first.should == @obj1
        end

        it "should return the last element in the set" do
          @array.last.should == @obj2
        end
      end

      describe "inspect" do
        before do
          @array = Odb::Proxy::Array.new
        end

        it "should look as an empty array typically looks with no values" do
          @array.inspect.should == "<Odb::Proxy::Array []>"
        end

        it "should prepend 'object_id' to an id" do
          @array << 1
          @array.inspect.should == "<Odb::Proxy::Array [object_id:1]>"
        end

        it "should display multiple ids" do
          @array << 1
          @array << 2
          @array.inspect.should == "<Odb::Proxy::Array [object_id:1, object_id:2]>"
        end
      end

      describe "caching" do
        before do
          @obj = mock 'object'
          Odb::Object.stub!(:read).and_return @obj
          @array = Odb::Proxy::Array.new(1)
        end

        it "should not lookup the same element twice" do
          @array.first
          Odb::Object.should_not_receive(:read)
          @array.first
        end
      end

      describe "reloading" do
        before do
          @obj = mock 'object'
          Odb::Object.stub!(:read).and_return @obj
          @array = Odb::Proxy::Array.new(1)
        end

        it "should not lookup the same element twice" do
          @array.first

          @array.reload
          Odb::Object.should_receive(:read)
          @array.first
        end
      end

      describe "map" do
        before do
          @obj = mock 'object'
          Odb::Object.stub!(:read).and_return @obj
          @array = Odb::Proxy::Array.new(1)
        end

        it "should return the objects" do
          elements = []
          @array.map { |e| elements << e }
          elements.should == [@obj]
        end
      end
    end
  end
end