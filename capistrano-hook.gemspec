# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/hook/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-hook'
  spec.version       = Capistrano::Hook::VERSION
  spec.authors       = ['yulii']
  spec.email         = ['yone.info@gmail.com']

  spec.summary       = 'Simple webhooks for Capistrano deployments.'
  spec.description   = 'Notification hooks include start, finish and fail of deployments.'
  spec.homepage      = 'https://github.com/yulii/capistrano-hook'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '>= 3.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock'
end
