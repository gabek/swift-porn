class ClassGenerator

  Property = Struct.new(:type, :name, :key, :originalType, :label)
  SwiftClass = Struct.new(:name, :properties, :enums)

  def self.handle_message(message)
    properties = []
    messageName = message.name

    message.field.each do |field|
      typename = TYPE_MAPPING[field.type] || field.type_name.split(".").last
      label = LABEL_MAPPING[field.label]
      property = Property.new(typename, field.name.camel_case_lower, field.name, field.type || field.type_name, label)
      properties.push(property)
    end

    swiftClass = SwiftClass.new(messageName, properties)
    return swiftClass
  end


  def self.render(swiftClass, indentLevel = 1)
    renderString = ""


      renderString += "class Base#{swiftClass.name}: object {" + String.newline
      # properties
      swiftClass.properties.each do |property|
        puts property.label
        propertyType = property.label == "repeated" ? "[#{property.type}]" : property.type
        renderString += String.indent(indentLevel) + "dynamic var #{property.name}: " +  propertyType + "?" + String.newline
      end

      # Nested enums
      # swiftClass.enums.each do |enum|
      #   renderString += String.newline
      #   renderString += EnumGenerator.render(enum)
      # end

      renderString += String.newline + String.indent(indentLevel) + "func mapping(map: Map) {"
      swiftClass.properties.each do |property|
        renderString += String.newline + String.indent(indentLevel + 1) + "#{property.name} <- map[\"#{property.key}\"]"
      end
      renderString += String.newline + String.indent(indentLevel) + "}"
      renderString += String.newline(2)

      renderString += String.newline + String.indent(indentLevel) + "required convenience init?(_ map: Map) {"
      renderString += String.newline + String.indent(indentLevel + 1) + "self.init()"
      renderString += String.newline + String.indent(indentLevel) + "}"

      renderString += String.newline(2)

      renderString += "}"

      renderString += String.newline(2)
    return renderString
  end

end
