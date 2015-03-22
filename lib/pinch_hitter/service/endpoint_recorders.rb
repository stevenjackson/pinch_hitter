module PinchHitter::Service
  class EndpointRecorders
    def recorders
      @recorders ||= {}
    end

    def record(endpoint, request)
      recorder_for(endpoint) << request
    end

    def requests(endpoint)
      recorder_for(endpoint)
    end

    def recorder_for(endpoint='/')
      recorders[endpoint] ||= []
    end

    def reset
      recorders.clear
    end
  end
end
