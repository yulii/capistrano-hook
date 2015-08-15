require 'test_helper'

module Capistrano
  module Tasks
    class WebhookTest < Minitest::Test
      def test_webhook_post_starting
        # set :webhook_url, 'https://yulii.github.io/services'
        # set :webhook_starting_payload, { text: 'Now, deploying...' }
        capture_io do
          Rake::Task['webhook:post:starting'].execute
        end
      end

      def test_webhook_post_finished
        capture_io do
          Rake::Task['webhook:post:finished'].execute
        end
      end

      def test_webhook_post_failed
        capture_io do
          Rake::Task['webhook:post:failed'].execute
        end
      end
    end
  end
end
