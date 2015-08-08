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
    end
  end
end
