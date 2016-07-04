require './lib/stringutils.rb'

Enum = Struct.new(:name, :cases)
EnumCase = Struct.new(:name, :value)

class EnumGenerator
  def self.handle_enum(enum)
    cases = []
    name = enum.name

    enum.value.each do |value|
      enumCase = EnumCase.new(value.name, value.number)
      cases.push(enumCase)
    end

    return Enum.new(name, cases)
  end

  def self.render(enum, indentLevel = 1)
    renderString = ""
    renderString += String.indent(indentLevel) + "enum #{enum.name}: String {" + String.newline
      enum.cases.each do |enumCase|
        renderString += String.indent(indentLevel + 1) + "case #{enumCase.name.camel_case} = \"#{enumCase.name}\"" + String.newline
      end
    renderString += String.indent(indentLevel) + "}" + String.newline(2)
  end

end
