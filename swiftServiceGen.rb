#!/usr/bin/ruby
# 07032016 GEK First stab at converting service.proto to Swift method signatures

require 'protocol_buffers'
require 'protocol_buffers/compiler'
require 'tempfile'
require 'protocol_buffers/compiler/file_descriptor_to_ruby'

require './FileDescriptorGenerator.rb'
require './stringutils.rb'

ServiceMethod = Struct.new(:name, :inputType, :outputType)

def generateSignature(method)
  methodName = method.name.split(".").last.uncapitalize
  signature = "func #{methodName}(request: #{method.inputType}, ((response: #{method.outputType} -> Void)?) = nil)"
  return signature
end

def generateDefaultImplementation(method)
  methodName = method.name.split(".").last.uncapitalize
  implementation = String.indent + "func #{methodName}(request: #{method.inputType}, ((response: #{method.outputType} -> Void)?) = nil) {" + String.newline
  implementation += "assertionFailure()"
  implementation += String.indent + "}" + String.newline(2)
  return implementation
end

filename = nil
ARGV.each do|file|
  filename = file
end

file_descriptor = FileDescriptorGenerator.generate(filename).file.first
methods = []

# Services
file_descriptor.service.each do |service|
  service.method.each do |method|
    name = "#{service.name}.#{method.name}"
    input = method.input_type.split(".").last
    output = method.output_type.split(".").last
    serviceMethod = ServiceMethod.new(name, input, output)
    methods.push(serviceMethod)
  end

  # Generate the service protocol
  puts "protocol #{service.name} {" + String.newline
  methods.each do |method|
    protocolSignature = String.indent(1)
    protocolSignature += generateSignature(method)
    puts protocolSignature
  end
  puts "}"

  puts String.newline(3)

  # Generate the default implementations
  # puts "extension #{service.name} {" + String.newline
  # methods.each do |method|
  #   signature = generateDefaultImplementation(method)
  #   puts signature
  # end
  # puts "}"

end




#func acceptUnderwritingDecision(underwritingDecisionId: String, success:((response: ApiResponse?) -> Void)? = nil, failure: ((response: ApiResponse?) -> Void)? = nil) {
