require 'pinch_hitter/message/json'

module PinchHitter::Message
  module ContentType
    include Json

    def determine_content_type(message)
      return "application/json" if valid_json? message
      "text/xml"
    end
  end
end
