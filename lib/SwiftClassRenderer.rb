require './lib/stringutils.rb'
require './lib/EnumGenerator.rb'
require './lib/ClassGenerator.rb'

class SwiftClassRenderer
  def self.render(classes, enums, withRealm = true, withObjectmapper = true)
    renderString = ""

    classes.each do |swiftClass|
      renderString += ClassGenerator.render(swiftClass, 1, withRealm, withObjectmapper)
    end

    enums.each do |swiftEnum|
      renderString += EnumGenerator.render(swiftEnum)
    end


    return renderString

  end
end
