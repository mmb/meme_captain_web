source 'https://rubygems.org'

gem 'rails', '~> 4.2', '>= 4.2.6'

group :assets do
  gem 'sass-rails', '~> 5.0', '>= 5.0.4'
  gem 'coffee-rails', '~> 4.2', '>= 4.2.1'
  gem 'uglifier', '~> 3.0'
end

gem 'jquery-rails', '~> 4.1', '>= 4.1.1'
gem 'therubyracer', '~> 0.12.2'
gem 'less-rails', '~> 2.7', '>= 2.7.1'

gem 'bcrypt', '~> 3.1', '>= 3.1.11'

gem 'dynamic_form', '~> 1.1', '>= 1.1.4'

gem 'rmagick',
    '~> 2.15',
    '>= 2.15.4',
    platforms: [:ruby, :mswin],
    require: 'rmagick'
gem 'rmagick4j', '~> 0.3.9', platforms: :jruby, require: 'rmagick'

gem 'delayed_job_active_record', '~> 4.1'
gem 'daemons', '~> 1.2', '>= 1.2.3'

gem 'meme_captain',
    git: 'https://github.com/mmb/meme_captain.git',
    ref: 'd80fb4b'

gem 'kaminari', '~> 0.16.3'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'puma', '~> 3.4'
gem 'browser', '~> 2.0', '>= 2.0.2'
gem 'faraday', '~> 0.9.2'
gem 'faraday-cookie_jar', '~> 0.0.6'
gem 'faraday_middleware', '~> 0.10.0'
gem 'ttfunk', '~> 1.4.0'
gem 'best_in_place', git: 'https://github.com/bernat/best_in_place.git'
gem 'local_time', '~> 1.0.3'
gem 'rubocop', '~> 0.38.0'
gem 'airbrake', '~> 4.1.0'
gem 'delayed-plugins-airbrake', '~> 1.1.0'
gem 'statsd-instrument', '~> 2.0', '>= 2.0.11'
gem 'data_uri', '~> 0.1.0'
gem 'remote_syslog_logger', '~> 1.0', '>= 1.0.3'
gem 'twitter_cldr', '~> 3.2', '>= 3.2.1'
gem 'addressable', '~> 2.4'
gem 'textacular', '~> 4.0'

group :test, :development do
  gem 'factory_girl_rails', '~> 4.6'
  # Should not be needed. Workaround described in:
  #   https://github.com/thoughtbot/shoulda-matchers/commit/6a0d0ff12a2c391a809327daa0ad311e5bd7159f
  gem 'rspec', '~> 3.5'
  gem 'rspec-rails', '~> 3.5', '>= 3.5.1'
  gem 'shoulda', '~> 3.5.0'
  gem 'jasmine-rails', '~> 0.12.4'
  gem 'sqlite3', '~> 1.3', '>= 1.3.11'
  gem 'rails_best_practices', '~> 1.16', platforms: [:jruby, :mri, :mswin]
  gem 'coffeelint', '~> 1.14'
  gem 'travis', '~> 1.8', '>= 1.8.2'
  gem 'capybara', '~> 2.6', '>= 2.6.2'
end

group :test do
  gem 'timecop', '~> 0.8.0'
  gem 'webmock', '~> 1.24', '>= 1.24.2'
end

group :production do
  gem 'dalli', '~> 2.7', '>= 2.7.6'
  gem 'pg', '~> 0.18.4'
  gem 'rack-rewrite', '~> 1.5.1'
  gem 'rack-cache', '~> 1.6', '>= 1.6.1'
end
