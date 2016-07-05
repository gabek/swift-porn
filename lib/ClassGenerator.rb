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


  def self.render(swiftClass, indentLevel = 1, withRealm = true, withObjectmapper = true)
    renderString = ""
      renderString += "class #{swiftClass.name}: "
      if withRealm
        renderString += "Object"
      end

      if withObjectmapper
        renderString += ", Mappable"
      end

      renderString += " {" + String.newline

      # properties
      swiftClass.properties.each do |property|
        renderString += String.indent(indentLevel)
        renderString += ClassGenerator.propertyLineForType(property, withRealm) + String.newline
      end

      # Nested enums
      swiftClass.enums.each do |enum|
        renderString += String.newline
        renderString += EnumGenerator.render(enum)
      end

      # Mapping function for serialization with ObjectMapper
      if withObjectmapper
        renderString += String.newline + String.indent(indentLevel) + "func mapping(map: Map) {"

        swiftClass.properties.each do |property|
          renderString += String.newline + String.indent(indentLevel + 1)

          # If this is an array AND we're using Realm we need to convert it to a Realm List<T>
          if property.label == "repeated" && withRealm
            renderString += "// Arrays need to be converted to a Realm list" + String.newline
            renderString += String.indent(indentLevel + 1) + "#{property.name} <- (map[\"#{property.key}\"], ArrayTransform<#{property.type}>())"
          else
            renderString += "#{property.name} <- map[\"#{property.key}\"]"
          end
        end
        renderString += String.newline + String.indent(indentLevel) + "}"
        renderString += String.newline(2)

        renderString += String.newline + String.indent(indentLevel) + "required convenience init?(_ map: Map) {"
        renderString += String.newline + String.indent(indentLevel + 1) + "self.init()"
        renderString += String.newline + String.indent(indentLevel) + "}"

        renderString += String.newline(2)
      end

      renderString += "}"


      renderString += String.newline(2)
    return renderString
  end

  def self.propertyLineForType(property, withRealm)
    # Certain swift types are not representable in Objective-C so they
    # must use the RealmOptional<T> type to represent them.
    typesUsingRealmOptional = ["Int", "Float", "Double", "Bool"]

    propertyType = property.type
    propertyLine = ""

    if withRealm
      if property.label == "repeated"
        propertyLine += "// Use List type so #{property.name} can be persisted in Realm" + String.newline + String.indent
        propertyLine += "var #{property.name} = List<" +  propertyType + ">()"
      elsif typesUsingRealmOptional.include?(property.type)
        propertyLine += "// #{property.type} objects must be wrapped in a RealmOptional" + String.newline + String.indent
        propertyLine += "var #{property.name} = RealmOptional<#{property.type}>()"
      else
        propertyLine += "dynamic var #{property.name}: #{property.type}?"
      end
    else
      propertyType = property.label == "repeated" ? "[#{property.type}]" : property.type
      propertyLine += "var #{property.name}: " +  propertyType + "?" + String.newline
    end

    return propertyLine
  end

end
