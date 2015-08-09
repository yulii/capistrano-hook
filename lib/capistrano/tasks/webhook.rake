namespace :webhook do
  desc <<-DESC
    Capistrano hook will not be run with no settings.

    You can setting the variables shown below.

      set :webhook_url, 'https://yulii.github.io'
      set :webhook_starting_payload, { text: 'Now, deploying...' }
      set :webhook_finished_payload, { text: 'Deployment has been completed!' }
      set :webhook_failed_payload,   { text: 'Oops! something went wrong.' }

  DESC

  def response_message(result, params)
    "POST webhook HTTP #{result.code} #{result.message} body='#{result.body}' payload=#{params}"
  end

  namespace :post do
    task :starting do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_starting_payload)
        next if payload.nil? || payload.empty?
        begin
          result = Capistrano::Hook::Web.client(url).post(payload)
          if result.is_a?(Net::HTTPSuccess)
            info response_message(result, payload)
          else
            error response_message(result, payload)
          end
        rescue StandardError => e
          error "[webhook:post:starting] #{e.class} #{e.message}"
        end
      end
    end

    task :finished do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_finished_payload)
        next if payload.nil? || payload.empty?
        begin
          result = Capistrano::Hook::Web.client(url).post(payload)
          if result.is_a?(Net::HTTPSuccess)
            info response_message(result, payload)
          else
            error response_message(result, payload)
          end
        rescue StandardError => e
          error "[webhook:post:finishing] #{e.class} #{e.message}"
        end
      end
    end

    task :failed do
      run_locally do
        url     = fetch(:webhook_url)
        payload = fetch(:webhook_failed_payload)
        next if payload.nil? || payload.empty?
        begin
          result = Capistrano::Hook::Web.client(url).post(payload)
          if result.is_a?(Net::HTTPSuccess)
            info response_message(result, payload)
          else
            error response_message(result, payload)
          end
        rescue StandardError => e
          error "[webhook:post:failed] #{e.class} #{e.message}"
        end
      end
    end

    before 'deploy:starting',  'webhook:post:starting'
    after  'deploy:finishing', 'webhook:post:finished'
    after  'deploy:failed',    'webhook:post:failed'
  end
end
