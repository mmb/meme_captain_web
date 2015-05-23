unless ENV['AIRBRAKE_API_KEY'].blank?
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_API_KEY']
  end

  Delayed::Worker.plugins << Delayed::Plugins::Airbrake::Plugin
end