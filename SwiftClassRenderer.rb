require './stringutils.rb'
require './EnumGenerator.rb'
require './ClassGenerator.rb'

class SwiftClassRenderer
  def self.render(classes, enums)
    renderString = ""

    classes.each do |swiftClass|
      renderString += ClassGenerator.render(swiftClass)
    end

    enums.each do |swiftEnum|
      renderString += EnumGenerator.render(swiftEnum)
    end


    return renderString

  end
end
