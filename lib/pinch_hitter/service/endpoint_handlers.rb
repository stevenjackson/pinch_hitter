require_relative 'message_queue'

module PinchHitter::Service
  class EndpointHandlers
    def handlers
      @handlers ||= {}
    end

    def store_message(endpoint, body)
      handler_for(endpoint) << body.squish
    end

    def respond_to(endpoint='/', request='')
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
      handlers[normalize(endpoint)] = handler
    end

    def normalize(endpoint)
      return endpoint if endpoint =~ /^\//
      "/#{endpoint}"
    end

    def reset
      handlers.values.each do |handler|
        if(handler.respond_to? :reset)
          handler.reset
        end
      end
    end
  end
end
