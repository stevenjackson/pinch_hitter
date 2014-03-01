module PinchHitter::Service
  class MessageQueue < Array
    def respond_to(msg=nil)
      requests << msg if msg
      shift
    end

    def requests
      @requests ||= []
    end

    def reset
      requests.clear
      clear
    end
  end
end
