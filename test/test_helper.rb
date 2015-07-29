$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'capistrano/hook'

require 'minitest/autorun'
require 'minitest/reporters'
require 'webmock/minitest'

Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
