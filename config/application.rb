require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups(assets: %w(development test)))

module MemeCaptainWeb
  # Main application class.
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those
    # specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_record.schema_format = :sql

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.x.src_image_name_lookup_host = nil
  end
end
