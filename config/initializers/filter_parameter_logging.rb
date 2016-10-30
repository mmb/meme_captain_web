# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password]

# Do not log url parameters because they could be large data URIs.
Rails.application.config.filter_parameters += [:url]
