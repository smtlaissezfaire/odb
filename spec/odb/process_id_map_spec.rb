require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Odb
  describe ProcessIdMap do
    it "should be a hash" do
      ProcessIdMap.should be_a_kind_of(Hash)
    end
  end
end