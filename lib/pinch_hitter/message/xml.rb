require 'rexml/document'
require 'rexml/xpath'

module PinchHitter::Message
  module Xml
    def xml_message(file, overrides={})
      xml = load_xml_file(file)
      overrides.each do |key, text|
        replace_xml(xml, key, text)
      end
      xml.to_s
    end

    private
    def load_xml_file(filename)
      file = File.new filename
      REXML::Document.new file
    end

    def replace_xml(xml, key, text)
      parts = key.split('@')
      tag = find_node xml, parts.first

      if parts.length == 1
        #match text node
        tag.text = text
      else
        #match attribute
        tag.attributes[parts.last] = text
      end
    end

    def find_node(xml, tag)
      REXML::XPath.first(xml, "//#{tag}")
    end
  end
end
