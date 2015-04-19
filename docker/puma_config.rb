directory '/app'

daemonize

pidfile '/var/run/puma.pid'

if ENV['PUMA_THREADS']
  threads(*ENV['PUMA_THREADS'].split(':').map(&:to_i))
end

preload_app!
