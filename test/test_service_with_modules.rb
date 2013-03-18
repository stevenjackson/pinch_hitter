
ENV['RACK_ENV'] = 'test'

require 'pinch_hitter/service/replay_ws'
require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'
require_relative 'message_assertions'

class TestService < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    PinchHitter::Service::ReplayWs
  end

  def test_module
    post '/store_module?endpoint=stuff', xml_module
    post '/stuff', ''

    assert_received xml_message
  end

  def xml_module
     %Q[module Test
        def respond_to(message)
          #{xml_message}
        end
      end]
  end
end
