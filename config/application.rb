require_relative 'boot'

require 'rails/all'

require_relative '../app/classes/meme_captain_web/instance_health'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups(assets: %w[development test]))

module MemeCaptainWeb
  # Main application class.
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those
    # specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_record.schema_format = :sql

    config.x.src_image_name_lookup_host = nil

    config.middleware.insert_before(0, MemeCaptainWeb::InstanceHealth)
  end
end
