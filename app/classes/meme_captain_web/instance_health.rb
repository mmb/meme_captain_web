module MemeCaptainWeb
  # Instance health check middleware.
  # Does not require a database connection to return ok.
  class InstanceHealth
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['PATH_INFO'] == '/instance_health'
        [200, {}, ['ok']]
      else
        @app.call(env)
      end
    end
  end
end
