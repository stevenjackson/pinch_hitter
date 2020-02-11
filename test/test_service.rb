ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require_relative 'message_assertions'

class TestService < MiniTest::Test
  include Rack::Test::Methods
  include MessageAssertions

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

    assert_equal 'application/json', last_response.content_type
  end

  def test_reset
    post "/reset", ''
    assert_equal 200, last_response.status
    post "/respond", ''
    assert_equal 404, last_response.status
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

  def test_put
    post '/store/endpoint1', xml_message
    put '/endpoint1'
    assert_received xml_message
  end

  def test_patch
    post '/store/endpoint1', xml_message
    patch '/endpoint1'
    assert_received xml_message
  end

  def test_delete
    post '/store/endpoint1', xml_message
    delete '/endpoint1'
    assert_received xml_message
  end

  def test_module
    post '/register_module?endpoint=stuff', Marshal.dump(TestModule)
    post '/stuff', ''

    assert_received xml_message
  end

  module TestModule
    include MessageAssertions
    def respond_to(message)
      xml_message
    end
  end

  def test_received_requests
    user_post = '{ "command": "Gimme stuff" }'
    post "/store?endpoint=do_things", xml_message
    post "/do_things", user_post
    get '/received_requests?endpoint=do_things'

    response = JSON.parse(last_response.body)['requests']
    assert_equal 1, response.length
    assert_equal user_post, response.first['body']
    assert response.first['headers']
  end

  def test_cache_control_defaults_to_nil
    post "/store", xml_message
    post "/respond", ''

    assert_nil last_response['Cache-Control']
  end

  def test_cache_control
    app.enable :no_cache
    post "/store", xml_message
    post "/respond", ''

    assert_equal 'no-cache, no-store', last_response['Cache-Control']
    app.disable :no_cache
  end

  def test_request_handler
    post '/register_module?endpoint=stuff', Marshal.dump(TestRequestHandler)
    post '/stuff', ''

    assert_received xml_message
    assert_equal 202, last_response.status
    assert(last_response.headers.include? "Kyrie")
  end

  module TestRequestHandler
    include MessageAssertions
    def handle_request(request, response)
      response.status = 202
      response["Kyrie"] =  "Irving"
      response.body = xml_message.squish
      response
    end
  end
end
