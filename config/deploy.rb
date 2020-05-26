# frozen_string_literal: true

# config valid only for current version of Capistrano
# lock '3.4.0'

set :application, 'capistrano-hook'
set :repo_url, 'git@github.com:yulii/capistrano-hook.git'
set :branch, :master

set :deploy_to, '/tmp'
set :format, :pretty
set :log_level, :debug

set :keep_releases, 5

# API Mock URL
MOCK_URL = {
  '200' => 'http://www.mocky.io/v2/55d33a90ec91e92b0e5e8e18',
  '406' => 'http://www.mocky.io/v2/55d6557a54774eed102a494c'
}.freeze

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
