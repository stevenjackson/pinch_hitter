module MessageAssertions
  def xml_message
    %Q{<?xml version="1.0" encoding="UTF-8"?>
      <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:replay="http://www.leandog.com/replay">
        <env:Body>
          <replay:Response>BARK!</replay:Response>
        </env:Body>
    </env:Envelope>}
  end

  def yml_message
   %Q~{"menu": {
      "id": "file",
      "value": "File"
    }}~
  end

  def assert_received(message)
    assert_equal message.gsub(/\n\s*/, ''), last_response.body.strip
  end
end
