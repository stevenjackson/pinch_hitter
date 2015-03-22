
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'

class TestEndpointRecorders < MiniTest::Test
  def setup
    @recorders = PinchHitter::Service::EndpointRecorders.new
  end

  def test_requests
    request = { body: '{"Hot Rod" : "Williams"}' }
    @recorders.record('endpoint', request)
    assert_equal [request], @recorders.requests('endpoint')
  end
end
