require 'test_helper'

module Capistrano
  module Tasks
    class WebhookTest < Minitest::Test
      def test_skip_webhook_post_starting_with_blank_url
        assert_silent_with_blank_url('starting')
      end

      def test_skip_webhook_post_finished_with_blank_url
        assert_silent_with_blank_url('finished')
      end

      def test_skip_webhook_post_failed_with_blank_url
        assert_silent_with_blank_url('failed')
      end

      def test_skip_webhook_post_reverting_with_blank_url
        assert_silent_with_blank_url('reverting')
      end

      def test_skip_webhook_post_rollbacked_with_blank_url
        assert_silent_with_blank_url('rollbacked')
      end

      def test_skip_webhook_post_starting_with_empty_payload
        assert_silent_with_empty_payload('starting')
      end

      def test_skip_webhook_post_finished_with_empty_payload
        assert_silent_with_empty_payload('finished')
      end

      def test_skip_webhook_post_failed_with_empty_payload
        assert_silent_with_empty_payload('failed')
      end

      def test_skip_webhook_post_reverting_with_empty_payload
        assert_silent_with_empty_payload('reverting')
      end

      def test_skip_webhook_post_rollbacked_with_empty_payload
        assert_silent_with_empty_payload('rollbacked')
      end

      def test_webhook_post_starting
        assert_silent_when_deployment_is_notified('starting')
      end

      def test_webhook_post_finished
        assert_silent_when_deployment_is_notified('finished')
      end

      def test_webhook_post_failed
        assert_silent_when_deployment_is_notified('failed')
      end

      def test_webhook_post_reverting
        assert_silent_when_deployment_is_notified('reverting')
      end

      def test_webhook_post_rollbacked
        assert_silent_when_deployment_is_notified('rollbacked')
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

      def assert_silent_with_blank_url(task)
        set :webhook_url, nil
        assert_nil fetch(:webhook_nil)
        capture_io do
          Rake::Task["webhook:post:#{task}"].execute
        end
      end

      def assert_silent_with_empty_payload(task)
        set :"webhook_#{task}_payload", {}
        assert_equal(fetch(:"webhook_#{task}_payload"), {})
        capture_io do
          Rake::Task["webhook:post:#{task}"].execute
        end
      end

      def assert_silent_when_deployment_is_notified(task)
        mock = Minitest::Mock.new
        mock.expect :post, http_response_ok, [fetch(:"webhook_#{task}_payload")]
        Capistrano::Hook::Web.stub(:client, mock) do
          capture_io do
            Rake::Task["webhook:post:#{task}"].execute
          end
        end
        mock.verify
      end
    end
  end
end
