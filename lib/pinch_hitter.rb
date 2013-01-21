require "pinch_hitter/version"
require "pinch_hitter/message/message_store"
require "pinch_hitter/service/runner"

module PinchHitter
  include PinchHitter::Service::Runner
  attr_accessor :message_store

  def messages_directory=(dir)
    self.message_store = PinchHitter::Message::MessageStore.new dir
  end

  def connect(host, port)
    self.session = Net::HTTP.new host, port
  end

  def session=(session)
    @session = session
  end

  def reset
    @session.post '/reset', ''
  end

  def prime(endpoint, message, overrides={})
    @session.post "/store?endpoint=#{endpoint}", message_store.load(message, overrides)
  end

end
