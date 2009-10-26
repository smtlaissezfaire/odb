namespace :protobuf do
  desc "Compile the protobuf file"
  task :compile do
    sh "rprotoc -o lib/odb lib/odb/object_format.proto"
  end
end