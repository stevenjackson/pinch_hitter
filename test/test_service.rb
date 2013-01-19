ENV['RACK_ENV'] = 'test'

require 'pinch_hitter/service/replay_ws'
require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'

class TestService < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    PinchHitter::Service::ReplayWs
  end

  def test_retrieve
    post "/store", xml_message 
    post "/respond", ''

    assert_received xml_message
    assert_equal 200, last_response.status
  end


  def test_result_should_be_xml
    post "/store", xml_message
    post "/respond", ''

    assert_equal 'text/xml;charset=utf-8', last_response.content_type
  end

  def test_result_should_be_json
    post "/store", yml_message
    post "/respond", ''

    assert_equal 'application/json;charset=utf-8', last_response.content_type
  end

  def test_reset
    post "/reset", ''
    assert_equal 200, last_response.status
    post "/respond", ''
    assert_equal 200, last_response.status
    assert_equal '', last_response.body
  end

  def test_store_with_params
    post '/store?endpoint=test2/subtest', yml_message 
    post '/test2/subtest', ''
    
    assert_received yml_message
  end

  def test_store_as_subendpoint
    post '/store/test2/subtest', yml_message 
    post '/test2/subtest', ''
    
    assert_received yml_message
  end
 

  def test_multi_endpoints
    post '/store/endpoint1', xml_message
    post '/store/endpoint2', yml_message
  
    post '/endpoint2', ''
    assert_received yml_message

    post '/endpoint1', ''
    assert_received xml_message
  end

  def test_multi_endpoint_queues
    post '/store/endpoint1', xml_message
    post '/store/endpoint1', xml_message
    post '/store/endpoint2', yml_message
    post '/store/endpoint2', yml_message
    post '/store/endpoint2', yml_message
  
    post '/endpoint2', ''
    assert_received yml_message
    post '/endpoint1', ''
    assert_received xml_message
    post '/endpoint1', ''
    assert_received xml_message
    post '/endpoint2', ''
    assert_received yml_message
    post '/endpoint2', ''
    assert_received yml_message
    #Out of queue
    post '/endpoint1', ''
    assert_equal '', last_response.body
  end

  def xml_message
    message = %Q{<?xml version="1.0" encoding="UTF-8"?>
      <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:replay="http://www.leandog.com/replay">
        <env:Body>
          <replay:Response>BARK!</replay:Response>
        </env:Body>
    </env:Envelope>}
  end

  def yml_message
   %Q~{"menu": {
      "id": "file",
      "value": "File"
    }}~
  end

  def assert_received(message)
    assert_equal message.gsub(/\n\s*/, ''), last_response.body.strip
  end
end
