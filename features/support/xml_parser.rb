module XmlParser
  def respond_to(message)
    if message.include? "ABC"
      result = "123"
    elsif message.include? "DEF"
      result = "Comedy Jam"
    end
    "<response>#{result}</response>"
  end
end
