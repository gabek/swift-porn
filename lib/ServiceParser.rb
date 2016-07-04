#!/usr/bin/ruby
# 07032016 GEK First stab at converting service.proto to Swift method signatures

require 'protocol_buffers'
require 'protocol_buffers/compiler'
require 'tempfile'
require 'protocol_buffers/compiler/file_descriptor_to_ruby'

require './lib/FileDescriptorGenerator.rb'
require './lib/stringutils.rb'

ServiceMethod = Struct.new(:name, :inputType, :outputType)

class ServiceParser
  def initialize(filename)
    @filename = filename
  end

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

  def parse
    file_descriptor = FileDescriptorGenerator.generate(@filename).file.first
    methods = []

    # Services
    renderString = ""

    file_descriptor.service.each do |service|
      service.method.each do |method|
        name = "#{service.name}.#{method.name}"
        input = method.input_type.split(".").last
        output = method.output_type.split(".").last

        serviceMethod = ServiceMethod.new(name, input, output)
        methods.push(serviceMethod)
      end

      # Generate the service protocol
      renderString += "protocol #{service.name} {" + String.newline
      methods.each do |method|
        renderString += String.indent(1)
        renderString += generateSignature(method)
      end
      renderString += "}"

      # Generate the default implementations
      # renderString += "extension #{service.name} {" + String.newline
      # methods.each do |method|
      #   signature = generateDefaultImplementation(method)
      #   renderString += signature
      # end
      
    end
    renderString += String.newline + "}"
    return renderString
  end
end
