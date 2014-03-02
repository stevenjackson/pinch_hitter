module PinchHitter::Service
  class EndpointRecorder
    attr_reader :handler

    def initialize(handler)
      @handler = handler
    end

    def store message
      handler << message if handler.respond_to? :<<
    end

    def respond_to(request)
      requests << request if request
      message = request[:body] if request
      handler.respond_to message
    end

    def requests
      @requests ||= []
    end

    def reset
      requests.clear
      handler.reset if handler.respond_to? :reset
    end
  end
end
