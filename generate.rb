#!/usr/bin/ruby

require 'thor'
require './lib/ModelParser.rb'
require './lib/ServiceParser.rb'
require './lib/stringutils.rb'

class CLI < Thor

  class_option :swiftpath, :type => :string, :desc => "Where Swift files should be generated", :default => "./swift"

  # Model
  desc('model message.proto', 'Generate Swift code from proto(s)')
  option "realm", :type => :boolean, :desc => "Enable generating models as a Realm object", :default => true
  option "objectmapper", :type => :boolean, :desc => "Enable ObjectMapper deserialization", :default => true

  def model(protoPath)
    outputFilename = protoPath.swiftname_from_protoname
    outputPath = "#{options[:swiftpath]}/#{outputFilename}"
    parser = ModelParser.new(protoPath)

    # Generate Swift code string
    generatedSwift = parser.parse(options["realm"], options["objectmapper"])

    # Save it to a new file
    puts "#{protoPath} => #{outputPath}"
    save(generatedSwift, outputPath)
  end

  # Service
  desc('service service.proto', 'Generate a Swift protocol from a service proto')
  def service(protoPath)
    outputFilename = "ServicesProtocol.swift"
    outputPath = "#{options[:swiftpath]}/#{outputFilename}"

    # Generate Swift code string
    parser = ServiceParser.new(protoPath)
    generatedSwift = parser.parse()

    # Save it to a new file
    puts "#{protoPath} => #{outputPath}"
    save(generatedSwift, outputPath)
  end

end

def save(string, path)
  File.open(path, 'w') { |file| file.write(string) }
end

CLI.start(ARGV)
