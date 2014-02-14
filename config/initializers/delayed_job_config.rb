# encoding: UTF-8

Delayed::Worker.delay_jobs = false if ENV['DELAY_JOBS'] == 'false'
