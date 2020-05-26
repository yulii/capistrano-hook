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
        client.post(payload: { text: 'Capistrano Hook Test!' })

        assert_equal(client.request.content_type, 'application/json')
        assert_equal(client.request.body, 'payload=%7B%3Atext%3D%3E%22Capistrano+Hook+Test%21%22%7D')
      end

      def test_self_client_with_https
        client = Capistrano::Hook::Web.client('https://stub.capistrano.hook')

        assert_equal(client.http.address, 'stub.capistrano.hook')
        assert_equal(client.http.port, 443)
        assert_equal(client.http.use_ssl?, true)
      end

      def test_post_request_with_https
        client = Capistrano::Hook::Web.client('https://stub.capistrano.hook')
        client.post(payload: { text: 'Capistrano Hook Test!' })

        assert_equal(client.request.content_type, 'application/json')
        assert_equal(client.request.body, 'payload=%7B%3Atext%3D%3E%22Capistrano+Hook+Test%21%22%7D')
      end

      private

      def setup
        stub_request(:any, 'http://stub.capistrano.hook')
        stub_request(:any, 'https://stub.capistrano.hook')
      end
    end
  end
end
