require 'test_helper'

module Capistrano
  module Tasks
    class WebhookTest < Minitest::Test
      def test_skip_webhook_post_starting
        set :webhook_starting_payload, {}
        assert_equal(fetch(:webhook_starting_payload), {})
        capture_io do
          Rake::Task['webhook:post:starting'].execute
        end
      end

      def test_skip_webhook_post_finished
        set :webhook_finished_payload, {}
        assert_equal(fetch(:webhook_finished_payload), {})
        capture_io do
          Rake::Task['webhook:post:finished'].execute
        end
      end

      def test_skip_webhook_post_failed
        set :webhook_failed_payload, {}
        assert_equal(fetch(:webhook_failed_payload), {})
        capture_io do
          Rake::Task['webhook:post:failed'].execute
        end
      end

      def test_webhook_post_starting
        mock = Minitest::Mock.new
        mock.expect :post, http_response_ok, [fetch(:webhook_starting_payload)]
        Capistrano::Hook::Web.stub(:client, mock) do
          capture_io do
            Rake::Task['webhook:post:starting'].execute
          end
        end
        mock.verify
      end

      def test_webhook_post_finished
        mock = Minitest::Mock.new
        mock.expect :post, http_response_ok, [fetch(:webhook_finished_payload)]
        Capistrano::Hook::Web.stub(:client, mock) do
          capture_io do
            Rake::Task['webhook:post:finished'].execute
          end
        end
        mock.verify
      end

      def test_webhook_post_failed
        mock = Minitest::Mock.new
        mock.expect :post, http_response_ok, [fetch(:webhook_failed_payload)]
        Capistrano::Hook::Web.stub(:client, mock) do
          capture_io do
            Rake::Task['webhook:post:failed'].execute
          end
        end
        mock.verify
      end

      private

      def setup
        set :webhook_url, 'https://yulii.github.io/services'
        set :webhook_starting_payload, text: 'Now, deploying...'
        set :webhook_finished_payload, text: 'Deployment has been completed!'
        set :webhook_failed_payload,   text: 'Oops! something went wrong.'
      end

      def http_response_ok
        Net::HTTPOK.new('1.1', '200', 'OK').tap do |response|
          response.instance_variable_set(:@read, true)
          response.body = 'ok'
        end
      end
    end
  end
end
