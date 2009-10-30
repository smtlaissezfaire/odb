require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Odb do
  before do
    FakeFS.activate!
  end
  
  after do
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end
  
  describe "init" do
    it "should create the odb directory" do
      Odb.init
      
      File.directory?("#{Dir.getwd}/odb").should be_true
    end
    
    it "should raise if the odb directory already exists" do
      Odb.init
      
      lambda {
        Odb.init
      }.should raise_error(LoadError, "ODB directory already exists!")
    end
    
    it "should put it at the path specified" do
      Dir.mkdir "/foo"
      Odb.init "/foo"
      
      File.directory?("/foo/odb").should be_true
    end
    
    it "should create the objects file" do
      Odb.init "/"
      
      File.exists?("/odb/objects").should be_true
    end
    
    it "should create the objects.idx file" do
      Odb.init "/"
      File.exists?("/odb/objects.idx").should be_true
    end
    
    it "should have nil as a pre-saved object"
    
    it "should have false as a pre-saved object"
    
    it "should have true as a pre-saved object"
  end
end