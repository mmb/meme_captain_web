if ENV['DELAY_JOBS'] == 'false'
  Delayed::Worker.delay_jobs = false
end
