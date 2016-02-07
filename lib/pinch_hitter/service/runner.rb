require 'rack'
require 'logger'
require 'webrick'
require 'pinch_hitter/service/replay_ws'

module PinchHitter::Service::Runner
  def silence_console
    @silent_console = true
  end

  def no_cache
    @no_cache = true
    @app.settings.enable :no_cache if @app
  end

  def start_service(host, port, timeout=10)
    Thread.abort_on_exception = true
    @app = PinchHitter::Service::ReplayWs.new
    @app.settings.enable :no_cache if @no_cache
    @replay_service = Thread.new do
      Rack::Handler::WEBrick.run @app, service_options(host, port)
    end
    wait_for_replay(timeout)
  end

  def service_options(host, port)
    {}.tap do |hash|
      hash[:Host] = host
      hash[:Port] = port
      hash[:AccessLog] = [] if @silent_console
      hash[:Logger] = SilentLogger.new if @silent_console
    end
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

  #Borrowed from https://github.com/watir/watirspec/blob/master/lib/silent_logger.rb
  class SilentLogger
    (::Logger.instance_methods - Object.instance_methods).each do |logger_instance_method|
      define_method(logger_instance_method) { |*args| }
    end
  end
end
