source 'https://rubygems.org'

gem 'rails', '~> 4.2.1'

group :assets do
  gem 'sass-rails', '~> 5.0'
  gem 'coffee-rails', '~> 4.1.0'
  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'
gem 'therubyracer', '~> 0.12.2'
gem 'less-rails'

gem 'bcrypt', '~> 3.1.7'

gem 'dynamic_form'

gem 'rmagick', '~> 2.15.3', platforms: [:ruby, :mswin], require: 'rmagick'
gem 'rmagick4j', '~> 0.3.9', platforms: :jruby, require: 'rmagick'

gem 'delayed_job_active_record', '~> 4.0.3'
gem 'daemons'

gem 'meme_captain',
    git: 'https://github.com/mmb/meme_captain.git',
    ref: 'd80fb4b'

gem 'kaminari', '~> 0.16.3'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'puma', '~> 2.14.0'
gem 'browser', '~> 1.0.1'
gem 'gravatar-ultimate', '~> 2.0.0'
gem 'faraday', '~> 0.9.1'
gem 'faraday-cookie_jar', '~> 0.0.6'
gem 'faraday_middleware', '~> 0.9.1'
gem 'ttfunk', '~> 1.4.0'
gem 'best_in_place', git: 'https://github.com/bernat/best_in_place.git'
gem 'local_time', '~> 1.0.3'
gem 'rubocop', '~> 0.34.2'
gem 'airbrake', '~> 4.1.0'
gem 'delayed-plugins-airbrake', '~> 1.1.0'
gem 'statsd-instrument', '~> 2.0.10'
gem 'data_uri', '~> 0.1.0'

group :test, :development do
  gem 'factory_girl_rails', '~> 4.5.0'
  # Should not be needed. Workaround described in:
  #   https://github.com/thoughtbot/shoulda-matchers/commit/6a0d0ff12a2c391a809327daa0ad311e5bd7159f
  gem 'rspec', '~> 3.3.0'
  gem 'rspec-rails', '~> 3.3.3'
  gem 'rspec-activemodel-mocks', '~> 1.0.1'
  gem 'shoulda', '~> 3.5.0'
  gem 'jasmine-rails', '~> 0.10.8'
  gem 'sqlite3', '~> 1.3.10'
  gem 'web-console', '~> 2.2.1'
  gem 'rails_best_practices', '~> 1.15.7'
  gem 'coffeelint', '~> 1.11.0'
  gem 'travis', '~> 1.8.0'
  gem 'capybara', '~> 2.5.0'
end

group :test do
  gem 'timecop', '~> 0.8.0'
  gem 'webmock', '~> 1.21.0'
end

group :production do
  gem 'dalli', '~> 2.7.4'
  gem 'pg', '~> 0.18.3'
  gem 'rack-rewrite', '~> 1.5.1'
  gem 'rack-cache', '~> 1.2'
end
