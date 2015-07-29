require 'json'
module Capistrano
  module Hook
    class Web
      private_class_method :new

      def initialize(url)
        @uri  = URI.parse(url).freeze
        @http = Net::HTTP.new(@uri.host, @uri.port)
        @http.use_ssl = @uri.is_a?(URI::HTTPS)
      end

      def post(params)
        # TODO: rescue / logger
        http.start do
          request = Net::HTTP::Post.new(uri.path)
          request.set_form_data(payload: params.to_json)
          http.request(request)
        end
      end

      def self.client(url)
        new(url)
      end

      protected

      attr_reader :uri, :http
    end
  end
end
