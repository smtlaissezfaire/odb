require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe Object do
    before do
      FakeFS.activate!
      Odb.init "/"
      Odb.path = "/"
    end
    
    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end
    
    describe "ids" do
      before do
        @index = Object.new
      end
      
      it "should be 1 with no lines in the file" do
        @index.next_id.should == 1
      end
      
      it "should have the next id based on the file length of the objects.idx file" do
        File.open("/odb/objects.idx", "w") { |f|
          f << "one\n"
          f << "two\n"
        }

        @index.next_id.should == 3
      end
    end
    
    describe "writing an object" do
      before do
        Odb.path = "/"
        @index = Object.new
      end
      
      describe "for a new, simple object" do
        before do
          @obj = ::Object.new
        end
        
        it "should return an object id" do
          @index.write(@obj).should be_a_kind_of(Fixnum)
        end
      
        it "should serialize the object" do
          Odb::Marshal.should_receive(:dump).with(@obj).and_return "astring"
        
          @index.write(@obj)
        end
      
        it "should add the id to the in-process map" do
          object_id = @index.write(@obj)
        
          ProcessIdMap[@obj].should == object_id
        end
      
        it "should write the object id to the objects.idx file" do
          object_id = @index.write(@obj)

          File.read("/odb/objects.idx").should == "#{object_id}\n"
        end
        
        it "should be able to write two different objects to the objects.idx file" do
          one, two = :foo, :bar
          
          @index.write(one)
          @index.write(two)
          
          File.read("/odb/objects.idx").split("\n").size.should == 2
        end
        
        def line_of file, line_num
          File.read(file).split("\n")[line_num.to_i]
        end
        
        def index_file_line line_num
          line_of("/odb/objects.idx", line_num)
        end
        
        def object_file_line line_num
          line_of("/odb/objects", line_num)
        end
        
        it "should write the object to the objects file" do
          str = Marshal.dump(@obj).gsub("\n", "")
          oid = @index.write(@obj)
          
          offset = index_file_line(oid)
          object_file_line(offset).should == str
        end
        
        it "should use a different object id for different objects" do
          oid1 = @index.write(@obj)
          oid2 = @index.write(::Object.new)
          
          oid1.should_not == oid2
        end
      end
      
      describe "for an already saved object (one which has already been loaded, and is in the process map)" do
        before do
          @obj = ::Object.new
        end
        
        it "should reuse the same object id for the same object" do
          oid1 = @index.write(@obj)
          oid2 = @index.write(@obj)
          
          oid1.should == oid2
        end
        
        it "should update the data" do
          pending 'write a functional test'
        end
        
        def line_of file, line_num
          File.read(file).split("\n")[line_num.to_i]
        end
        
        def index_file_line line_num
          line_of("/odb/objects.idx", line_num)
        end
        
        def object_file_line line_num
          line_of("/odb/objects", line_num)
        end
        
        it "should return the oid based on the offset in the index file, not the objects file" do
          File.open("/odb/objects", "w") { |f| f << "stuff\nfoo\n\bar\n"}
          
          oid = @index.write(@obj)
          
          oid.should == File.read("/odb/objects.idx").split("\n").size
        end
        
        it "should return the oid based on the offset in the index file, not the objects file when updated" do
          File.open("/odb/objects", "w") { |f| f << "stuff\nfoo\n\bar\n"}
          
          oid1 = @index.write(@obj)
          oid2 = @index.write(@obj)
          
          length = File.read("/odb/objects.idx").split("\n").size
          
          oid1.should == length
          oid2.should == length
        end
        
        it "should set the new offset in the index file (increase it by 1, assuming no concurrent access)" do
          oid = @index.write(@obj)
          
          lambda {
            @index.write(@obj)
          }.should change { index_file_line(oid-1).to_i }.by(1)
        end
        
        def length_of file
          File.readlines(file).size
        end
        
        it "should update the index with the new location" do
          object_id = @index.write(@obj)
          @index.write(@obj)
          
          line_of("/odb/objects.idx", object_id - 1).to_i.should == length_of("/odb/objects")
        end
      end
    end
  end
end
