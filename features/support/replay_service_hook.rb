require 'rack'
require 'webrick'
require 'pinch_hitter/service/replay_ws'

Thread.abort_on_exception = true
@replay_service = Thread.new { start_replay }

at_exit do
  @replay_service.kill
end

def start_replay(host=app_host, port=app_port)
  Rack::Handler::WEBrick.run PinchHitter::Service::ReplayWs.new, :Host => host, :Port => port
end
