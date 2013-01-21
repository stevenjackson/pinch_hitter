require 'rspec-expectations'
require 'pinch_hitter'
require 'net/http'

def app_host
  '127.0.0.1'
end

def app_port
  9292
end

def app
  @app ||= Net::HTTP.new app_host, app_port
end

def mock
  @@mock ||= MockWebService.new app_host, app_port
end

def messages
  mock.message_store
end

at_exit do
  mock.stop_service
end

