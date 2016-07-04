class String
  def camel_case_lower
    self.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
  end

  def camel_case
    return self.split('_').collect(&:capitalize).join
  end

  def self.newline(num=1)
    newlines = ""
    num.times do
      newlines += "\r\n"
    end
    return newlines
  end

  def self.indent(levels=1)
    tabs = ""
    levels.times do
      tabs += "  "
    end
    return tabs
  end

  def uncapitalize
    self[0, 1].downcase + self[1..-1]
  end

  def swiftname_from_protoname
    return self.split("/").last.split(".").first.capitalize + ".swift"
  end
end
