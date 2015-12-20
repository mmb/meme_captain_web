Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_run_time = 90.seconds
if Rails.env.production?
  Delayed::Worker.logger =
    MemeCaptainWeb::Syslog.new.logger(ENV, 'delayed_job'.freeze) ||
      Logger.new(Rails.root.join('log'.freeze, 'delayed_job.log'.freeze))
end
Delayed::Worker.delay_jobs = false if ENV['DELAY_JOBS'] == 'false'
