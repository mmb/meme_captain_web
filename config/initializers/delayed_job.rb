Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_run_time = 90.seconds
if Rails.env.production?
  Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'delayed_job.log'))
end
Delayed::Worker.delay_jobs = false if ENV['DELAY_JOBS'] == 'false'
