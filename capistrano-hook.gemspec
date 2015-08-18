# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
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

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'rubocop'
end
