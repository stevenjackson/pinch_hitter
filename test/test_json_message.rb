
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'

class TestJsonMessage < MiniTest::Unit::TestCase

  def setup
   File.open(filename, 'w') {|f| f.write(our_message) }
   @test = Object.new
   @test.extend(PinchHitter::Message::Json)
  end

  def teardown
    File.delete filename
  end

  def filename
    "minitest_message.json"
  end

  def our_message
%Q{{"menu": {
  "id": "file",
  "value": "File",
  "popup": {
    "menuitem": "OpenDoc()"
  }
}}
}
  end

  def test_message_no_overrides 
    assert_equal our_message, @test.json_message(filename)
  end

  def test_message_with_overrides
    json = @test.json_message(filename, {["menu", "popup", "menuitem"] => 'WhatsUpDoc?' })
    assert json.include? "WhatsUpDoc?"
  end
end
