ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'pinch_hitter/service/endpoint_handlers'


class TestEndpointHandlers < MiniTest::Unit::TestCase

  def setup
    @handlers = PinchHitter::Service::EndpointHandlers.new
  end

  def json
    %Q{{"key"::"value"}}
  end

  def test_message_queue
    @handlers.store_message 'endpoint', json 
    handler = @handlers.handler_for 'endpoint'
    assert_instance_of(PinchHitter::Service::MessageQueue, handler)
    assert_equal json, handler.respond_to 
  end

  def test_defaults_to_message_queue
    @handlers.store_message 'endpoint', json
    assert_equal json, @handlers.respond_to('endpoint')
  end

  def test_register_module
    @handlers.register_module('endpoint', TestModule)
    assert_equal "THIS IS A TEST", @handlers.respond_to('endpoint')
  end

  def test_reset_clears_message_queues
    @handlers.store_message 'endpoint', json
    @handlers.reset
    assert_nil @handlers.respond_to('endpoint')
  end

  def test_reset_does_not_clear_modules
    @handlers.register_module('endpoint', TestModule)
    @handlers.reset
    assert_equal "THIS IS A TEST", @handlers.respond_to('endpoint')
  end

  def test_register_module_with_marshalling
    mod = Marshal.dump(TestModule)
    @handlers.register_module('endpoint', Marshal.load(mod))
    assert_equal "THIS IS A TEST", @handlers.respond_to('endpoint')
  end


  module TestModule
    def respond_to(msg)
      test_message
    end
    def test_message
      "THIS IS A TEST"
    end
  end
end
