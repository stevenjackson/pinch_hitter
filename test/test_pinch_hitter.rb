ENV['RACK_ENV'] = 'test'

require 'pinch_hitter/service/replay_ws'
require 'pinch_hitter'
require 'minitest/autorun'
require 'rack/test'

class TestPinchHitter < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
   @test = Object.new
   @test.extend(PinchHitter)
   @test.session=session
  @test.messages_directory = File.dirname('.')
   File.open(message_file, 'w') {|f| f.write(message_content) }
  end

  def teardown
    File.delete message_file
  end

  def message_file
    "fizzbuzz"
  end

  def message_content
    "{fizzbuzz}"
  end
  
  def app
    PinchHitter::Service::ReplayWs
  end

  def session
    @session ||= Rack::Test::Session.new(Rack::MockSession.new(app))
  end

  def test_message_store_init
   @test.messages_directory = "/bar" 
   assert_equal "/bar", @test.message_store.message_directory
  end

  def test_service_reset
    @test.reset
    assert_equal '/reset', session.last_request.path_info
  end

  def test_prime
    @test.prime '/foo', message_file.to_sym
    session.get '/foo'
    assert_equal message_content, session.last_response.body
  end

  def test_store
    @test.store '/foo', message_content
    session.get '/foo'
    assert_equal message_content, session.last_response.body
  end

end
