require "spec_helper"

class Foo
  attr_accessor :bar
end

describe "read and write simple objects" do
  before do
    FakeFS.activate!
    Odb.init "/"
    Odb.path = "/"
  end
    
  after do
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

  it "should be able to read a previously written object" do
    pending do
      @obj = Foo.new
      @obj.bar = 17
      
      oid = Odb::Object.new.write(@obj)
      
      object = Odb::Object.new.read oid
      object.should be_a_kind_of(Foo)
      object.bar.should == 17
    end
  end
end
