# frozen_string_literal: true

require 'json'
require 'net/http'
module Capistrano
  module Hook
    class Web
      attr_reader :uri, :http, :request
      private_class_method :new

      def initialize(url, headers = {})
        @uri     = URI.parse(url).freeze
        @http    = Net::HTTP.new(uri.host, uri.port)
        @request = Net::HTTP::Post.new(path)

        http.use_ssl = uri.is_a?(URI::HTTPS)
        request.initialize_http_header(default_headers.merge(headers))
      end

      def post(params)
        http.start do
          request.body = params.to_json
          http.request(request)
        end
      end

      def self.client(url)
        new(url)
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
    end
  end
end
