require 'protocol_buffers'
require 'protocol_buffers/compiler'
require 'tempfile'
require 'protocol_buffers/compiler/file_descriptor_to_ruby'

class FileDescriptorGenerator
  def self.generate(filename)
    protocfile = Tempfile.new("ruby-protoc")
    protocfile.binmode
    ProtocolBuffers::Compiler.compile(protocfile.path, [filename], :include_dirs => false)
    descriptor_set = Google::Protobuf::FileDescriptorSet.parse(protocfile)
    protocfile.close(true)

    return descriptor_set
  end
end
