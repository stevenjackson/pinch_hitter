module PinchHitter
  module Service
    class ResponseQueues

      def reset
        @responses = {}
      end

      def responses 
        @responses ||= {}
      end

      def store(endpoint, body)
        endpoint_responses(endpoint) << body.gsub(/\n\s*/, '')
      end

      def retrieve(endpoint='/')
        endpoint_responses(endpoint).shift
      end

      def endpoint_responses(endpoint='/')
        endpoint = "/#{endpoint}" unless endpoint =~ /^\//
        queue = responses[endpoint] || []
        responses[endpoint] = queue
        queue
      end
    end
  end
end
