require "spec"
require File.expand_path(File.dirname(__FILE__) + "/../lib/odb")

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../vendor/fakefs/lib")

Spec::Runner.configure do |config|
  config.before do
    Odb::ProcessIdMap.clear
    Odb.path = nil
  end
  
  config.after do
    Odb.path = nil
  end
end
