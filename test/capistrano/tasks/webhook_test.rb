require 'test_helper'

module Capistrano
  module Tasks
    class WebhookTest < Minitest::Test
      def test_skip_webhook_post_starting_with_blank_url
        assert_silent_with_blank_url('webhook:post:starting')
      end

      def test_skip_webhook_post_finished_with_blank_url
        assert_silent_with_blank_url('webhook:post:finished')
      end

      def test_skip_webhook_post_failed_with_blank_url
        assert_silent_with_blank_url('webhook:post:failed')
      end

      def test_skip_webhook_post_reverting_with_blank_url
        assert_silent_with_blank_url('webhook:post:reverting')
      end

      def test_skip_webhook_post_rollbacked_with_blank_url
        assert_silent_with_blank_url('webhook:post:rollbacked')
      end

      def test_skip_webhook_post_starting_with_empty_payload
        set :webhook_starting_payload, {}
        assert_equal(fetch(:webhook_starting_payload), {})
        capture_io do
          Rake::Task['webhook:post:starting'].execute
        end
      end

      def test_skip_webhook_post_finished_with_empty_payload
        set :webhook_finished_payload, {}
        assert_equal(fetch(:webhook_finished_payload), {})
        capture_io do
          Rake::Task['webhook:post:finished'].execute
        end
      end

      def test_skip_webhook_post_failed_with_empty_payload
        set :webhook_failed_payload, {}
        assert_equal(fetch(:webhook_failed_payload), {})
        capture_io do
          Rake::Task['webhook:post:failed'].execute
        end
      end

      def test_skip_webhook_post_reverting_with_empty_payload
        set :webhook_reverting_payload, {}
        assert_equal(fetch(:webhook_reverting_payload), {})
        capture_io do
          Rake::Task['webhook:post:reverting'].execute
        end
      end

      def test_skip_webhook_post_rollbacked_with_empty_payload
        set :webhook_rollbacked_payload, {}
        assert_equal(fetch(:webhook_rollbacked_payload), {})
        capture_io do
          Rake::Task['webhook:post:rollbacked'].execute
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

      def test_webhook_post_reverting
        mock = Minitest::Mock.new
        mock.expect :post, http_response_ok, [fetch(:webhook_reverting_payload)]
        Capistrano::Hook::Web.stub(:client, mock) do
          capture_io do
            Rake::Task['webhook:post:reverting'].execute
          end
        end
        mock.verify
      end

      def test_webhook_post_rollbacked
        mock = Minitest::Mock.new
        mock.expect :post, http_response_ok, [fetch(:webhook_rollbacked_payload)]
        Capistrano::Hook::Web.stub(:client, mock) do
          capture_io do
            Rake::Task['webhook:post:rollbacked'].execute
          end
        end
        mock.verify
      end

      private

      def setup
        set :webhook_url, 'https://yulii.github.io/services'
        set :webhook_starting_payload,   text: 'Now, deploying...'
        set :webhook_finished_payload,   text: 'Deployment has been completed!'
        set :webhook_failed_payload,     text: 'Oops! something went wrong.'
        set :webhook_reverting_payload,  text: 'Reverting...'
        set :webhook_rollbacked_payload, text: 'Rollback has been completed!'
      end

      def http_response_ok
        Net::HTTPOK.new('1.1', '200', 'OK').tap do |response|
          response.instance_variable_set(:@read, true)
          response.body = 'ok'
        end
      end

      def assert_silent_with_blank_url(name)
        set :webhook_url, nil
        assert_equal(fetch(:webhook_nil), nil)
        capture_io do
          Rake::Task[name].execute
        end
      end
    end
  end
end
