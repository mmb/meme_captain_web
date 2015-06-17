source 'https://rubygems.org'

gem 'rails', '~> 4.2.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 5.0'
  gem 'coffee-rails', '~> 4.1.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'
gem 'therubyracer'
gem 'less-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'dynamic_form'

gem 'rmagick', platforms: [:ruby, :mswin], require: 'rmagick'
gem 'rmagick4j', platforms: :jruby, require: 'rmagick'

gem 'delayed_job_active_record', '~> 4.0.3'
gem 'daemons'

gem 'meme_captain'

gem 'kaminari', '~> 0.16.1'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'puma', '~> 2.11.3'
gem 'browser', '~> 0.8.0'
gem 'gravatar-ultimate'
gem 'faraday', '~> 0.9.1'
gem 'faraday-cookie_jar', '~> 0.0.6'
gem 'faraday_middleware', '~> 0.9.1'
gem 'ttfunk', '~> 1.4.0'
gem 'best_in_place', git: 'https://github.com/bernat/best_in_place.git'
gem 'local_time', '~> 1.0.0'
gem 'rubocop', '~> 0.32.0'
gem 'airbrake', '~> 4.1.0'
gem 'delayed-plugins-airbrake', '~> 1.1.0'

group :test, :development do
  gem 'factory_girl_rails'
  # Should not be needed. Workaround described in:
  #   https://github.com/thoughtbot/shoulda-matchers/commit/6a0d0ff12a2c391a809327daa0ad311e5bd7159f
  gem 'rspec', '~> 3.2.0'
  gem 'rspec-rails', '~> 3.2.1'
  gem 'rspec-activemodel-mocks', '~> 1.0.1'
  gem 'shoulda', '~> 3.5.0'
  gem 'webrat', '~> 0.7.3'
  gem 'jasmine-rails', '~> 0.10.8'
  gem 'sqlite3'
  gem 'web-console', '~> 2.0'
  gem 'w3c_validators', '~> 1.2'
  gem 'rails_best_practices', '~> 1.15.7'
end

group :test do
  gem 'timecop'
  gem 'webmock', '~> 1.21.0'
end

group :production do
  gem 'dalli'
  gem 'pg', '~> 0.18.2'
  gem 'rack-rewrite'
  gem 'rack-cache', '~> 1.2'
end
