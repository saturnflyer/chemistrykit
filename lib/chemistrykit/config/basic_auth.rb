# Encoding: utf-8

module ChemistryKit
  module Config
    class BasicAuth

      attr_accessor :username, :password, :base_url, :http_path, :https_path

      def initialize(opts)
        opts.each do |key, value|
          begin
            send("#{key}=", value)
          rescue NoMethodError
            raise ArgumentError.new "The config key: \"#{key}\" is unknown!"
          end
        end
      end

      def http?
        !!http_path
      end

      def https?
        !!https_path
      end

      def http_url
        base_url.gsub(%r{http://}, "http:\/\/#{username}:#{password}@") + (http_path || '')
      end

      def https_url
        base_url.gsub(%r{http://}, "https:\/\/#{username}:#{password}@") + (https_path || '')
      end

    end
  end
end
