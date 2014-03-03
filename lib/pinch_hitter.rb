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
    store endpoint, message_store.load(message, overrides)
  end

  def store(endpoint, content)
    @session.post "/store?endpoint=#{endpoint}", content
  end

  def register_module(endpoint, handler)
    @session.post "/register_module?endpoint=#{endpoint}", Marshal.dump(handler)
  end

  def request_log(endpoint)
    requests = @session.get "/received_requests?endpoint=#{endpoint}"
    requests = JSON.parse(requests.body)['requests']
    requests.map { |h| Struct.new(:body, :headers).new(h['body'], h['headers']) }
  end

  def received_messages(endpoint)
    request_log(endpoint).map { |request| request.body }
  end

end
