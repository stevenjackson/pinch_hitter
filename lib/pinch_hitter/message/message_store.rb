require 'pinch_hitter/message/xml'
require 'pinch_hitter/message/json'
require 'pinch_hitter/message/content_type'

module PinchHitter::Message
    class MessageStore
    include Xml
    include Json
    include ContentType

    attr_accessor :message_directory

    def initialize(message_directory)
      @message_directory = message_directory
    end

    def load(file, overrides={})
      filename = find_filename file
      if filename =~ /xml$/
        xml_message filename, overrides
      else
        json_message filename, overrides
      end
    end

    def find_filename(file)
      filename = Dir["#{message_directory}/#{file}*"].first
      unless filename
        fail "Could not find message for '#{file}' in '#{File.expand_path(File.dirname(message_directory))}'"
      end
      filename
    end

  end
end
