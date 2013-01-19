module PinchHitter
  module Message
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
        modified = child = parent = JSON.parse(content).clone
        overrides.each do |key, value| 

          key.each do |part|
            parent = child 
            child = parent.send "fetch", part
          end
          parent[key.last] = value
        end
        modified.to_s
      end
    end
  end
end
