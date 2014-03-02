require_relative 'message_queue'
require_relative 'endpoint_recorder'

module PinchHitter::Service
  class EndpointHandlers
    def handlers
      @handlers ||= {}
    end

    def store_message(endpoint, body)
      handler_for(endpoint).store body.squish
    end

    def respond_to(endpoint='/', request=nil)
      message = handler_for(endpoint).respond_to(request)
      message.squish if message
    end

    def requests(endpoint)
      handler_for(endpoint).requests
    end

    def handler_for(endpoint='/')
      handlers[normalize(endpoint)] || store_handler(endpoint)
    end

    def register_module(endpoint, mod)
      handler = Object.new
      handler.extend(mod)
      store_handler(endpoint, handler)
    end

    def store_handler(endpoint, handler=MessageQueue.new)
      handlers[normalize(endpoint)] = EndpointRecorder.new handler
    end

    def normalize(endpoint)
      return endpoint if endpoint =~ /^\//
      "/#{endpoint}"
    end

    def reset
      handlers.values.each(&:reset)
    end
  end
end
