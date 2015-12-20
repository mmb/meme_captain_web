module MemeCaptainWeb
  # Configuration of remote syslog from environment variable.
  class Syslog
    def logger(env, program)
      return if env['SYSLOG'.freeze].to_s.empty?
      syslog_host, syslog_port = env['SYSLOG'.freeze].split(':'.freeze)
      RemoteSyslogLogger.new(syslog_host, syslog_port.to_i, program: program)
    end
  end
end
