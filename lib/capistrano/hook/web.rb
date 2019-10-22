# frozen_string_literal: true

require 'json'
require 'net/http'
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
          http.request(request(params))
        end
      end

      def request(params)
        Net::HTTP::Post.new(uri.path).tap do |o|
          o.set_form_data(payload: params.to_json)
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
