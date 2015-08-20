namespace :webhook do
  desc <<-DESC
    Capistrano hook will not be run with no settings.

    You can setting the variables shown below.

      set :webhook_url, 'https://yulii.github.io'
      set :webhook_starting_payload,   { text: 'Now, deploying...' }
      set :webhook_finished_payload,   { text: 'Deployment has been completed!' }
      set :webhook_failed_payload,     { text: 'Oops! something went wrong.' }
      set :webhook_reverting_payload,  { text: 'Reverting...' }
      set :webhook_rollbacked_payload, { text: 'Rollback has been completed!' }

  DESC

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

  namespace :post do
    task :starting do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_starting_payload)
        webhook(url, payload)
      end
    end

    task :finished do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_finished_payload)
        webhook(url, payload)
      end
    end

    task :failed do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_failed_payload)
        webhook(url, payload)
      end
    end

    task :reverting do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_reverting_payload)
        webhook(url, payload)
      end
    end

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
