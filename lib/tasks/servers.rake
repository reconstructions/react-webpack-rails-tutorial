if %w[development test].include? Rails.env
  namespace :servers do
    # Server ports can be assets in 'development.env'.  Servers will start on
    # default port settings if variables aren't set in that file.  Default
    # values are:
    #
    # PORT=5000
    # ACTION_CABLE_PORT=3000
    # REDIS_PORT=6379

    desc "Start Postgres"
    task :start_postgres do
      sh "postgres -D /usr/local/var/postgres"
    end

    desc "Start Redis supporting ActionCable"
    task :start_redis do
      sh "redis-server --port ${REDIS_PORT:-6379}"
    end

    desc "Starts a Rails server."
    task :start_rails do
      sh "foreman start -e development.env -f Procfile"
    end

    desc "Starts a Rails server and client & server Webpack bundling."
    task :start_static_rails_webpack do
      sh "foreman start -e development.env -f Procfile.static"
    end

    desc "Starts a Rails server with TRACE_REACT_ON_RAILS and client & server Webpack bundling."
    task :start_static_trace_rails_webpack do
      sh "foreman start -e development.env -f Procfile.static.trace"
    end

    desc "Starts client & server Webpack bundlers."
    task :start_webpack_specs_bundler do
      sh "foreman start -f Procfile.spec"
    end

    desc "Kills process by name"
    task :kill, :process do |_t, args|
      sh "kill $(ps aux | grep -E '#{args[:process]}' | grep -v grep | " \
      "awk '{print $2}'); true"
    end

    desc "Kill postgres"
    task :kill_postgres do
      Rake::Task["servers:kill"].invoke("postgres")
    end

    desc "Kill redis"
    task :kill_redis do
      Rake::Task["servers:kill"].invoke("redis")
    end

    desc "Gets process PID's by name"
    task :pid, :process do |_t, args|
      sh "ps aux | grep -E '#{args[:process]}' | grep -v grep | " \
      "awk '{print $2}'"
    end
  end
end
