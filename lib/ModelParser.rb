# 07022016 GEK Generate Swift classes from protos

require 'protocol_buffers/compiler'

load "./lib/TypeMap.rb"
require './lib/EnumGenerator.rb'
require './lib/ClassGenerator.rb'
require './lib/stringutils.rb'
require './lib/SwiftClassRenderer.rb'
require './lib/FileDescriptorGenerator.rb'

class ModelParser
  def initialize(filename)
    @filename = filename
  end

   def parse(withRealm = true, withObjectmapper = true)
    descriptor_set = FileDescriptorGenerator.generate(@filename)

    classes = []
    enums = []

    descriptor_set.file.each do |file_descriptor|

      # Messages
      file_descriptor.message_type.each do |message|
        swiftClass = ClassGenerator.handle_message(message)

        # Handle nested enums
        nested_enums = []
        message.enum_type.each do |enum|
          swiftEnum = EnumGenerator.handle_enum(enum)
          nested_enums.push(swiftEnum)
        end

        swiftClass.enums = nested_enums
        classes.push(swiftClass)
      end


      # Enums
      file_descriptor.enum_type.each do |enum|
        enums.push(EnumGenerator.handle_enum(enum))
      end

      renderString = String.newline(2)
      renderString += "import Foundation" + String.newline

      if withRealm
        renderString += "import RealmSwift" + String.newline
      end

      if withObjectmapper
        renderString += "import ObjectMapper" + String.newline
      end

      renderString += String.newline

      renderString += SwiftClassRenderer.render(classes, enums, withRealm, withObjectmapper)
      return renderString
    end
  end
end
