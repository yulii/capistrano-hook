# frozen_string_literal: true

#  Capistrano hook will not be run with no settings.
#
#  You can setting the variables shown below.
#
#    set :webhook_url, 'https://yulii.github.io'
#    set :webhook_starting_payload,   { text: 'Now, deploying...' }
#    set :webhook_finished_payload,   { text: 'Deployment has been completed!' }
#    set :webhook_failed_payload,     { text: 'Oops! something went wrong.' }
#    set :webhook_reverting_payload,  { text: 'Reverting...' }
#    set :webhook_rollbacked_payload, { text: 'Rollback has been completed!' }

namespace :webhook do
  def webhook(url, payload)
    return if url.nil? || payload.nil? || payload.empty?

    info "POST #{url} payload='#{payload}'"
    result = Capistrano::Hook::Web.client(url).post(payload)
    message = "HTTP #{result.code} #{result.message} body='#{result.body}'; "
    if result.is_a?(Net::HTTPSuccess)
      info message
    else
      error message
    end
  end

  namespace :config do
    desc 'List the webhook configured variables'
    task :list do
      run_locally do
        keys = %i[webhook_url
                  webhook_starting_payload
                  webhook_finished_payload
                  webhook_failed_payload
                  webhook_reverting_payload
                  webhook_rollbacked_payload].sort
        padding = keys.max_by(&:length).length
        keys.each do |key|
          next if fetch(key).nil? || fetch(key).empty?

          puts ":#{key.to_s.ljust(padding)} => #{fetch(key)}"
        end
      end
    end
  end

  namespace :post do
    desc 'Post a starting message if :webhook_url and :webhook_starting_payload are present'
    task :starting do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_starting_payload)
        webhook(url, payload)
      end
    end

    desc 'Post a finished message if :webhook_url and :webhook_finished_payload are present'
    task :finished do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_finished_payload)
        webhook(url, payload)
      end
    end

    desc 'Post a failed message if :webhook_url and :webhook_failed_payload are present'
    task :failed do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_failed_payload)
        webhook(url, payload)
      end
    end

    desc 'Post a reverting message if :webhook_url and :webhook_reverting_payload are present'
    task :reverting do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_reverting_payload)
        webhook(url, payload)
      end
    end

    desc 'Post a rollbacked message if :webhook_url and :webhook_rollbacked_payload are present'
    task :rollbacked do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_rollbacked_payload)
        webhook(url, payload)
      end
    end

    before 'deploy:starting',           'webhook:post:starting'
    after  'deploy:finishing',          'webhook:post:finished'
    after  'deploy:failed',             'webhook:post:failed'
    before 'deploy:reverting',          'webhook:post:reverting'
    after  'deploy:finishing_rollback', 'webhook:post:rollbacked'
  end
end
