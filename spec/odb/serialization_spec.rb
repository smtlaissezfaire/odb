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
    
    # class TestingTargetClass
    #   include Odb::Serialize
    #   
    #   attr_accessor :attribute_one
    # end
    # 
    # class TestingClassTwo
    #   include Odb::Serialize
    # end
    # 
    # before do
    #   @obj = TestingTargetClass.new
    # end
    # 
    # it "should be able to dump an object through Marshal" do
    #   @obj.dump.should == Marshal.dump(@obj)
    # end
    # 
    describe "on including the class" do
      it "should create the odb file path" do
        Odb.stub!(:database_path).and_return "/foo"
        
        Class.new do
          include Odb::Serialize
        end
        
        File.exists?("/foo").should be_true
      end
      
      it "should create the correct path" do
        Odb.stub!(:database_path).and_return "/bar"
        
        Class.new do
          include Odb::Serialize
        end
        
        File.exists?("/bar").should be_true
      end
      
      it "should create the directories recursively" do
        Odb.stub!(:database_path).and_return "/foo/bar"
        
        Class.new do
          include Odb::Serialize
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
        end
        
        File.exists?("/foo/bar/FooBar").should be_true
      end
      
      # it "should save a file path with the class name, underscored" do
      #   
      #   
      #   Dir.mkdir "/foo"
      #   Dir.mkdir "/foo/bar"
      #   
      #   Odb.stub!(:database_path).and_return "/foo/bar"
      #   
      #   @obj.commit
      #   
      #   File.exists?("/foo/bar/testing_target_class").should be_true
      # end
      
      # it "should use the correct path" do
      #   Dir.mkdir "/foo"
      #   
      #   Odb.stub!(:database_path).and_return "/foo"
      #   
      #   @obj.commit
      #   
      #   File.exists?("/foo/testing_target_class").should be_true
      # end
      # 
      # it "should use the correct class name" do
      #   Dir.mkdir "/foo"
      #   
      #   Odb.stub!(:database_path).and_return "/foo"
      #   
      #   @obj.commit
      #   
      #   File.exists?("/foo/testing_class_two").should be_true
      # end
    end
    
    describe "finding all"
    
    describe "finding by attribute" do
      it "should be able to find based on an attribute"
      
      it "should not find it if it does not exist"
      
      it "should find based on the correct attribute"
    end
  end
end