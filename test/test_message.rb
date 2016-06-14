ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'

class TestMessage < MiniTest::Test

  def setup
   File.open("#{xml_filename}.xml", 'w') {|f| f.write(xml_message) }

   File.open("#{json_file}", 'w') { |f| f.write(json_message) }

   @messages = PinchHitter::Message::MessageStore.new File.dirname('.')
  end

  def teardown
    File.delete "#{xml_filename}.xml"
    File.delete "#{json_file}"
  end

  def xml_filename
    "minitest_xml"
  end

  def json_file
    "minitest_json"
  end

  def xml_message
%Q{<?xml version='1.0' encoding='UTF-8'?>
<Body/>
}
  end

  def json_message
%Q{{
  "one": "two",
  "A": "B" }
}
  end

  def test_setting_dir
    @messages.message_directory = "/foo"
    assert_equal "/foo", @messages.message_directory
  end

  def test_loads_xml
    assert_equal xml_message, @messages.load(xml_filename.to_sym)
  end

  def test_loads_json
    assert_equal json_message, @messages.load(json_file.to_sym)
  end

  def test_message_no_whitespace
    squish = %Q{<?xml version='1.0' encoding='UTF-8'?><Body/>}
    assert_equal squish, @messages.load(xml_filename.to_sym).squish
  end

  def test_content_type_defaults_to_xml
    assert_equal "text/xml", @messages.determine_content_type("")
  end

  def test_content_type_determines_json
    assert_equal "application/json", @messages.determine_content_type(json_message)
  end
end
