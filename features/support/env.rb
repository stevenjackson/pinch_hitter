require 'rspec-expectations'
require 'pinch_hitter'
require 'net/http'

class MockWebService
  include PinchHitter

  def initialize
    self.connect '127.0.0.1', 9292
    self.messages_directory = File.join(File.dirname('.'), 'features', 'messages')
  end

end

def mock
  @mock ||= MockWebService.new
end

def app
  @app ||= Net::HTTP.new '127.0.0.1', 9292
end

def messages
  mock.message_store
end

