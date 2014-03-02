ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'

class TestEndpointRecorder < MiniTest::Test

  def setup
    @mock = MiniTest::Mock.new
    @recorder = PinchHitter::Service::EndpointRecorder.new @mock
  end

  def test_is_facade_for_handler
    @mock.expect(:<<, nil, ['blah'])
    @recorder.store 'blah'
    @mock.verify
  end

  def test_is_facade_reset
    @mock.expect(:reset, nil)
    @recorder.reset
    @mock.verify
  end

  def test_stores_request_if_present
    @mock.expect(:respond_to, '', [String])
    @recorder.respond_to({ body: 'request' })
    assert_equal [{body: 'request'}], @recorder.requests
  end

  def test_passes_body_to_handler_if_present
    @mock.expect(:respond_to, '', ['request'])
    @recorder.respond_to({ body: 'request' })
    @mock.verify
  end

  def reset_clears_stored_requests
    @mock.expect(:respond_to, '', [String])
    @mock.expect(:reset, nil)
    @recorder.respond_to({ body: 'request' })
    @recorder.reset
    assert_empty @recorder.requests
  end
end
