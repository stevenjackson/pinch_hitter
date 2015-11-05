module PinchHitter::Message
  module Json
    def json_message(file, overrides={})
      json_file = load_json_file file
      replace_json json_file, overrides
    end

    def valid_json?(json)
      begin
        JSON.parse json
        return true
      rescue
        return false
      end
    end

  private
    def load_json_file(filename)
      IO.read filename
    end

    def replace_json(content, overrides={})
      return content if overrides.empty?
      doc = JSON.parse(content)
      overrides.each do |key, value|
        hash = find_nested_hash(doc, key)
        if has_key(hash, key)
          hash[key] = value
        end
      end
      doc.to_json
    end

    def find_nested_hash(parent, key)
      return parent if has_key(parent, key)
      return nil unless parent.respond_to? :each

      found = nil
      parent.find do |parent_key, child|
        found = find_nested_hash(child, key)
      end
      found
    end

    def has_key(hash, key)
      hash.respond_to?(:key?) && hash.key?(key)
    end

  end
end
