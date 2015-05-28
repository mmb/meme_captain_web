directory '/app'

daemonize

pidfile '/var/run/puma.pid'

threads(*ENV['PUMA_THREADS'].split(':').map(&:to_i)) if ENV['PUMA_THREADS']

preload_app!
