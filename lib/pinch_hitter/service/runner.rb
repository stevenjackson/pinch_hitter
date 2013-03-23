require 'rack'
require 'webrick'
require 'pinch_hitter/service/replay_ws'

module PinchHitter
  module Service
    module Runner

      def start_service(host, port, timeout=10)
        Thread.abort_on_exception = true
        @app = PinchHitter::Service::ReplayWs.new
        @replay_service = Thread.new do
          Rack::Handler::WEBrick.run @app, :Host => host, :Port => port
        end
        wait_for_replay(timeout)
      end

      def stop_service
        @replay_service.kill
      end

      private 
      def wait_for_replay(timeout)
        end_time = ::Time.now + timeout
        until ::Time.now > end_time
          sleep 0.25
          return if @replay_service.stop?
        end
        raise 'Timed out waiting for replay service to start'
      end
    end
  end
end
