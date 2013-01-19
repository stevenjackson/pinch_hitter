require 'nokogiri'

module PinchHitter
  module Message
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
        Nokogiri::XML File.open filename
      end

      def replace_xml(xml, key, text)
        parts = key.split('@')
        tag = find_node xml, parts.first

        if parts.length == 1
          #match text node
          tag.content = text
        else
          #match attribute
          tag[parts.last] = text
        end
      end

      def find_node(xml, tag)
        xml.at_xpath("//#{tag}", xml.collect_namespaces)
      end
    end
  end
end
