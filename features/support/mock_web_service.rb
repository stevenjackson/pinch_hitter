class MockWebService
  include PinchHitter

  def initialize(host, port)
    self.connect host, port
    self.messages_directory = File.join(File.dirname('.'), 'features', 'messages')
  end

end
