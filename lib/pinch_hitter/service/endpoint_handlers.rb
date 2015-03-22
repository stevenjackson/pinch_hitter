require 'pinch_hitter/core_ext/string'
require 'pinch_hitter/core_ext/nil_class'
require_relative 'message_queue'

module PinchHitter::Service
  class EndpointHandlers
    def handlers
      @handlers ||= {}
    end

    def store_message(endpoint, message)
      handler = handler_for(endpoint)
      handler.store(message.squish) if handler.respond_to? :store
    end

    def respond_to(endpoint='/', request=nil)
      message = handler_for(endpoint).respond_to(request)
      message.squish
    end

    def handler_for(endpoint='/')
      handlers[endpoint] || store_handler(endpoint)
    end

    def register_module(endpoint, mod)
      handler = Object.new
      handler.extend(mod)
      store_handler(endpoint, handler)
    end

    def store_handler(endpoint, handler=MessageQueue.new)
      handlers[endpoint] = handler
    end

    def reset
      handlers.values.each do |handler|
        handler.reset if handler.respond_to? :reset
      end
    end
  end
end
