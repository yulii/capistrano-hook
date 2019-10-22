# frozen_string_literal: true

require 'test_helper'

module Capistrano
  module Hook
    class WebTest < Minitest::Test
      def test_private_methods_definition
        methods = Capistrano::Hook::Web.private_methods

        assert_includes(methods, :new)
      end

      def test_protected_methods_definition
        methods = Capistrano::Hook::Web.allocate.protected_methods

        assert_includes(methods, :http)
        assert_includes(methods, :uri)
      end

      def test_self_client_with_http
        client = Capistrano::Hook::Web.client('http://yulii.github.io')
        uri    = client.instance_variable_get(:@uri)
        http   = client.instance_variable_get(:@http)

        assert_equal(uri.frozen?,   true)
        assert_equal(http.address,  'yulii.github.io')
        assert_equal(http.port,     80)
        assert_equal(http.use_ssl?, false)
      end

      def test_self_client_with_https
        client = Capistrano::Hook::Web.client('https://yulii.github.io')
        uri    = client.instance_variable_get(:@uri)
        http   = client.instance_variable_get(:@http)

        assert_equal(uri.frozen?,   true)
        assert_equal(http.address,  'yulii.github.io')
        assert_equal(http.port,     443)
        assert_equal(http.use_ssl?, true)
      end
    end
  end
end
