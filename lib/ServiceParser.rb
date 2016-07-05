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
    signature = "func #{methodName}(request: #{method.inputType}, completionHandler: ((#{method.outputType}? -> Void)?))"
    return signature
  end

  def generateDefaultImplementation(method)
    methodName = method.name.split(".").last.uncapitalize
    implementation = String.indent + "func #{methodName}(request: #{method.inputType}, completionHandler: ((#{method.outputType}? -> Void)?) = nil) {" + String.newline
    implementation += String.indent(2) + "let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())" + String.newline
    implementation += String.indent(2) + "let url = NSURL(string: \"http://something.net/#{method.name}\")!" + String.newline
    implementation += String.indent(2) + "let dataTask = defaultSession.dataTaskWithURL(url) {" + String.newline
    implementation += String.indent(3) + "data, response, error in" + String.newline
    implementation += String.indent(4) + "// Handle response" + String.newline
    implementation += String.indent(4) + "let #{method.outputType.uncapitalize} = Mapper<#{method.outputType}>().map(data)" + String.newline
    implementation += String.indent(4) + "completionHandler?(#{method.outputType.uncapitalize})" + String.newline
    implementation += String.indent(3) + "}" + String.newline
    implementation += String.indent(2) + "dataTask.resume()" + String.newline

    implementation += String.indent + "}" + String.newline(2)
    return implementation
  end

  def parse
    file_descriptor = FileDescriptorGenerator.generate(@filename).file.first
    methods = []

    # Services
    renderString = String.newline(2) + "import Foundation" + String.newline
    renderString += "import ObjectMapper" + String.newline(2)

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
        renderString += String.newline + "}"
      end

      # Generate the default implementations
      renderString += String.newline(2)
      renderString += "extension #{service.name} {" + String.newline
      methods.each do |method|
        signature = generateDefaultImplementation(method)
        renderString += signature
        renderString += "}"
      end

    end
    return renderString
  end
end
