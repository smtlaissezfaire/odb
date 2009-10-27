require "spec"
require File.expand_path(File.dirname(__FILE__) + "/../lib/odb")

Spec::Runner.configure do |config|
  config.before do
    Odb::ProcessIdMap.clear
  end
end