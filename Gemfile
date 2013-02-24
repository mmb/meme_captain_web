source 'https://rubygems.org'

gem 'rails', '3.2.9'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'dynamic_form'

gem 'rmagick', :platforms => [:ruby, :mswin], :require => 'RMagick'
gem 'rmagick4j', :platforms => :jruby, :require => 'RMagick'

gem 'delayed_job_active_record'
gem 'daemons'

gem 'meme_captain'

gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'thin'

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 2.0'
  gem 'shoulda'
  gem 'webrat'
  gem 'jasmine-headless-webkit'
  gem 'sqlite3'
  gem 'travis_heroku'
end

group :test do
  gem 'webmock'
end

group :production do
  gem 'dalli'
  gem 'pg'
end
