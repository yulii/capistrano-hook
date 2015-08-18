# Capistrano::Hook

[![Gem Version](https://badge.fury.io/rb/capistrano-hook.svg)](http://badge.fury.io/rb/capistrano-hook)
[![Build Status](https://travis-ci.org/yulii/capistrano-hook.svg)](https://travis-ci.org/yulii/capistrano-hook)
[![Code Climate](https://codeclimate.com/github/yulii/capistrano-hook/badges/gpa.svg)](https://codeclimate.com/github/yulii/capistrano-hook)
[![Dependency Status](https://gemnasium.com/yulii/capistrano-hook.svg)](https://gemnasium.com/yulii/capistrano-hook)

Notification hooks include start, finish and fail of deployments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-hook'
```

## Usage

Add this line to your Capfile:

```ruby
require 'capistrano/hook'
```

Capistrano hook will not be run with no settings. You can setting the variables shown below.

```ruby
set :webhook_url, 'https://yulii.github.io/services'
set :webhook_starting_payload,   { text: 'Now, deploying...' }
set :webhook_finished_payload,   { text: 'Deployment has been completed!' }
set :webhook_failed_payload,     { text: 'Oops! something went wrong.' }
set :webhook_reverting_payload,  { text: 'Reverting...' }
set :webhook_rollbacked_payload, { text: 'Rollback has been completed!' }
```

Test your setup by running:
```
cap production webhook:post:starting
cap production webhook:post:finished
cap production webhook:post:failed
cap production webhook:post:reverting
cap production webhook:post:rollbacked
```


### Slack

Send notifications to Slack via incoming webhooks.

```ruby
set :webhook_url, 'https://yulii.github.io/services'
set :webhook_starting_payload, {
  username:   'Capistrano',
  icon_emoji: ':monkey_face:',
  text:       'Now, deploying...'
}
set :webhook_finished_payload, {
  username:   'Capistrano',
  icon_emoji: ':monkey_face:',
  text:       'Deployment has been completed!'
}
set :webhook_failed_payload, {
  username:   'Capistrano',
  icon_emoji: ':monkey_face:',
  text:       'Oops! something went wrong.'
}
```

[Slack API - Incoming Webhooks](https://api.slack.com/incoming-webhooks)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yulii/capistrano-hook. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

