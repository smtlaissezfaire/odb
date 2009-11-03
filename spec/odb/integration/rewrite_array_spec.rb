require "spec_helper"

module Odb
  describe "Rewriting an array" do
    before do
      FakeFS.activate!
      Odb.init "/"
      Odb.path = "/"
    end

    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end

    it "should be able to refetch the array" do
      obj = "foo"
      a = [obj]

      oid = Odb::Object.write(a)

      array = Odb::Object.read(oid)

      oid = Odb::Object.write(array)

      array.first.should == "foo"
    end

    it "should not change the object id" do
      pending 'FIXME' do
        obj = "foo"
        a = [obj]

        oid1 = Odb::Object.write(a)

        array = Odb::Object.read(oid1)

        oid2 = Odb::Object.write(array)

        oid1.should == oid2
      end
    end
  end
end