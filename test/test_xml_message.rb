ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'

class TestXmlMessage < MiniTest::Test

  def setup
   File.open(filename, 'w') {|f| f.write(our_message) }
   @test = Object.new
   @test.extend(PinchHitter::Message::Xml)
  end

  def teardown
    File.delete filename
  end

  def filename
    "minitest_message.xml"
  end

  def our_message
%Q{<?xml version="1.0" encoding="UTF-8"?>
<wrapper>
  <Body xmlns:ns="http://www.abc.org/OTA/2003/05">
    <node>text</node>
    <withattrib attrib="value"/>
    <ns:testnode>text</ns:testnode>
  </Body>
</wrapper>
}
  end

  def test_message_no_overrides 
    assert_equal our_message, @test.xml_message(filename)
  end

  def test_message_tag_override
    xml = @test.xml_message(filename, {"node" => "newtext"})
    assert xml.include? "<node>newtext</node>"
  end

  def test_message_tag_override_attrib
    xml = @test.xml_message(filename,
        {"withattrib@attrib" => "BetterValue"})
    assert xml.include? "<withattrib attrib=\"BetterValue\""
  end

  def test_message_tag_override_with_namespace
    xml = @test.xml_message(filename, {"ns:testnode" => 'newValue'})
    assert xml.include? "<ns:testnode>newValue</ns:testnode>"
  end
end
