require "spec_helper"

module Odb
  module Proxy
    describe Hash do
      before do
        @hash = Odb::Proxy::Hash.new
        @obj = mock 'object'
      end

      it "should be able to add a key-value pair" do
        @hash[:key] = 1
        @hash.has_key?(:key).should be_true
      end

      it "should not has_key? if the key is not stored" do
        @hash.has_key?(:foo).should be_false
      end

      it "should fetch a value by object id" do
        Odb::Object.stub!(:read).and_return @obj

        @hash[:key] = 1
        @hash[:key].should == @obj
      end

      it "should use the correct key (should not find a value which isn't there)" do
        Odb::Object.stub!(:read).and_return @obj

        @hash[:foo].should be_nil
      end

      it "should cache an object" do
        Odb::Object.stub!(:read).and_return @obj

        @hash[:foo] = 1
        @hash[:foo]

        Odb::Object.should_not_receive(:read)
        @hash[:foo]
      end

      it "should be able to give a hash to Hash.new" do
        h = Hash.new({:foo => 1})
        h.has_key?(:foo).should be_true
      end

      it "should have store as an alias for []" do
        hash = Hash.new

        hash.method(:[]).should == hash.method(:store)
      end

      it "should clear by proxying" do
        internal = {}

        hash = Hash.new(internal)

        internal.should_receive(:clear)

        hash.clear
      end

      it "should proxy empty? to the hash" do
        internal = {}
        hash = Hash.new(internal)

        internal.should_receive(:empty?)
        hash.empty?
      end

      describe "==" do
        it "should delegate" do
          internal_hash_one, internal_hash_two = {}, {}

          @hash1 = Hash.new(internal_hash_one)
          @hash2 = Hash.new(internal_hash_two)

          internal_hash_one.should_receive(:==).with(internal_hash_two).and_return true

          @hash1 == @hash2
        end

        it "should be false if the other thing doesn't respond to object_proxy_hash" do
          (@hash1 == Object.new).should be_false
        end
      end
    end
  end
end
