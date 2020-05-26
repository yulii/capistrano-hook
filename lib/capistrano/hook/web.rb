# frozen_string_literal: true

require 'json'
require 'net/http'
module Capistrano
  module Hook
    class Web
      attr_reader :uri, :http, :request, :headers
      private_class_method :new

      def initialize(url, headers)
        @uri     = URI.parse(url).freeze
        @headers = headers
        initialize_http
        initialize_request
      end

      def post(params)
        http.start do
          request.body = params.to_json
          http.request(request)
        end
      end

      def self.client(url, headers = {})
        new(url, headers)
      end

      private

      def path
        return '/' if uri.path.nil?
        return '/' if uri.path.empty?

        uri.path
      end

      def default_headers
        { 'Content-Type' => 'application/json' }
      end

      def initialize_http
        @http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.is_a?(URI::HTTPS)
      end

      def initialize_request
        @request = Net::HTTP::Post.new(path)
        request.initialize_http_header(default_headers.merge(headers))
      end
    end
  end
end
