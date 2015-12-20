# encoding: UTF-8

MemeCaptainWeb::Application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  MemeCaptainWeb::AssetHostConfig.new.configure(config, ENV)
  MemeCaptainWeb::SrcImageNameLookupConfig.new.configure(config, ENV)

  config.serve_static_files = true
  config.middleware.insert_before(
    ActionDispatch::Static,
    Rack::Deflater,
    if: ->(_, _, headers, _) { headers['Content-Type'][0..5] != 'image/' })
  config.static_cache_control = 'public, max-age=31536000'

  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and
  # use secure cookies.
  # config.force_ssl = true

  config.log_level = :info

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  syslog_logger = MemeCaptainWeb::Syslog.new.logger(ENV, 'rails'.freeze)
  config.logger = syslog_logger if syslog_logger

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Precompile additional assets (application.js, application.css, and all
  # non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.eager_load = true

  if ENV['MEMCACHE_SERVERS']
    config.cache_store = :dalli_store

    config.action_dispatch.rack_cache = {
      metastore: Dalli::Client.new,
      entitystore: 'file:tmp/cache/rack/body',
      allow_reload: false
    }
  end
end
