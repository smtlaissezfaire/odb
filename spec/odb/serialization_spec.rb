require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'fakefs/safe'

module Odb
  describe Serialize do
    before do
      FakeFS::FileSystem.clear
      FakeFS.activate!
    end
    
    after do
      FakeFS.deactivate!
    end
    
    describe "after including + calling serialize" do
      it "should create the odb file path" do
        Odb.stub!(:database_path).and_return "/foo"
        
        Class.new do
          include Odb::Serialize
          serialize
        end
        
        File.exists?("/foo").should be_true
      end
      
      it "should create the correct path" do
        Odb.stub!(:database_path).and_return "/bar"
        
        Class.new do
          include Odb::Serialize
          serialize
        end
        
        File.exists?("/bar").should be_true
      end
      
      it "should create the directories recursively" do
        Odb.stub!(:database_path).and_return "/foo/bar"
        
        Class.new do
          include Odb::Serialize
          serialize
        end
        
        File.directory?("/foo").should be_true
        File.directory?("/foo/bar").should be_true
      end
      
      it "should create a file for the class given" do
        Odb.stub!(:database_path).and_return "/foo/bar"
        
        klass = Class.new do
          def self._database_name
            "klass_name"
          end
          
          include Odb::Serialize
          serialize
        end
        
        File.exists?("/foo/bar/klass_name").should be_true
      end
      
      it "should use the klass's _database_name name" do
        Odb.stub!(:database_path).and_return "/foo/bar"
        
        klass = Class.new do
          def self._database_name
            "FooBar"
          end
          
          include Odb::Serialize
          serialize
        end
        
        File.exists?("/foo/bar/FooBar").should be_true
      end
      
      it "should use the to_s name if none is given" do
        Odb.stub!(:database_path).and_return "/foo/bar"
        
        klass = Class.new do
          def self.to_s
            "FooBar"
          end
          
          include Odb::Serialize
          serialize
        end
        
        File.exists?("/foo/bar/FooBar").should be_true
      end
    end
    
    class TestingClass
      include Odb::Serialize
      
      attr_accessor :an_attribute
    end
    
    class EqualTestingClass
      include Odb::Serialize
      
      def ==(other)
        true
      end
    end
    
    describe "committing" do
      before do
        Odb.stub!(:database_path).and_return "/foo/bar"
        
        TestingClass.serialize
        
        @obj = TestingClass.new
      end
      
      it "should save without an error" do
        lambda {
          @obj.commit
        }.should_not raise_error
      end
      
      it "should marshal the data to disk" do
        @obj.commit
        
        File.read("/foo/bar/#{@obj.class.to_s}").should == Marshal.dump([@obj])
      end
      
      it "should replace the data if already marshaled in the past (if they are the same with ==)" do
        EqualTestingClass.serialize
        obj = EqualTestingClass.new
        
        obj.commit
        obj.commit
        
        EqualTestingClass.all.size.should == 1
      end
    end
    
    describe "finding all" do
      before do
        Odb.stub!(:database_path).and_return "/foo"
        
        TestingClass.serialize
      end
      
      it "should find no records when empty" do
        TestingClass.all.should == []
      end
      
      it "should find a record after commiting it" do
        obj = TestingClass.new
        obj.an_attribute = "foobar"
        
        obj.commit
        
        TestingClass.all.size.should == 1
        TestingClass.all.first.an_attribute.should == "foobar"
      end
      
      it "should find multiple records" do
        obj_one = TestingClass.new
        obj_two = TestingClass.new
        
        obj_one.commit
        obj_two.commit
        
        TestingClass.all.size.should == 2
      end
    end
    
    describe "finding by attribute" do
      before do
        Odb.stub!(:database_path).and_return "/foo"
        TestingClass.serialize
      end
      
      it "should be able to find based on an attribute" do
        obj = TestingClass.new
        obj.an_attribute = "foo"
        obj.commit
        
        found = TestingClass.find_by_attribute("an_attribute", "foo")
        found.size.should == 1
      end
      
      it "should be able to find only the first row which matches" do
        obj = TestingClass.new
        obj.an_attribute = "foo"
        obj.commit
        
        obj2 = TestingClass.new
        obj2.an_attribute = "foo"
        obj.commit
        
        found = TestingClass.find_first_by_attribute("an_attribute", "foo")
        found.should be_a_kind_of(TestingClass)
      end
    end
  end
end