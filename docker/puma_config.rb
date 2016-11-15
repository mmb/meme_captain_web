directory '/app'

daemonize

pidfile '/run/puma.pid'

threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count
