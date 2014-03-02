module PinchHitter::Service
  class MessageQueue < Array
    def respond_to(msg=nil)
      shift
    end

    def reset
      clear
    end
  end
end
