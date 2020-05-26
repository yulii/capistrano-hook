# frozen_string_literal: true

require 'test_helper'

module Capistrano
  module Hook
    class WebTest < Minitest::Test
      def test_self_client_with_http
        client = Capistrano::Hook::Web.client('http://stub.capistrano.hook')

        assert_equal(client.http.address, 'stub.capistrano.hook')
        assert_equal(client.http.port, 80)
        assert_equal(client.http.use_ssl?, false)
      end

      def test_post_request_with_http
        client = Capistrano::Hook::Web.client('http://stub.capistrano.hook')
        client.post(params)

        assert_equal(client.request.content_type, 'application/json')
        assert_equal(client.request.body, params.to_json)
      end

      def test_self_client_with_https
        client = Capistrano::Hook::Web.client('https://stub.capistrano.hook')

        assert_equal(client.http.address, 'stub.capistrano.hook')
        assert_equal(client.http.port, 443)
        assert_equal(client.http.use_ssl?, true)
      end

      def test_post_request_with_https
        client = Capistrano::Hook::Web.client('https://stub.capistrano.hook')
        client.post(params)

        assert_equal(client.request.content_type, 'application/json')
        assert_equal(client.request.body, params.to_json)
      end

      private

      def setup
        stub_request(:any, 'http://stub.capistrano.hook')
        stub_request(:any, 'https://stub.capistrano.hook')
      end

      def params
        { text: 'Capistrano Hook Test!' }
      end
    end
  end
end
