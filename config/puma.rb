# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads Integer(ENV.fetch('RAILS_MIN_THREADS') { 4 } ), Integer(ENV.fetch('RAILS_MAX_THREADS') { 16 } )

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers Integer(ENV.fetch('PUMA_WORKERS') { 3 })

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
preload_app!

rackup DefaultRackup

if ENV['BIND']
  bind ENV['BIND']
else
  # Specifies the `port` that Puma will listen on to receive requests; default is 3000.
  #
  port ENV.fetch('PORT') { 3000 }
end

# Specifies the `environment` that Puma will run in.
#
environment ENV['RACK_ENV'] || 'production'

unless ENV['DATABASE_URL']
  if File.exist?('config/pghero.yml')
    ENV['DATABASE_URL'] = 'nulldb:///'
  else
    abort "No DATABASE_URL or config/pghero.yml"
  end
end

# If you are preloading your application and using Active Record, it's
# recommended that you close any connections to the database before workers
# are forked to prevent connection leakage.
#
# For PgHero we do not need to do this if ENV['DATABASE_URL'] == 'nulldb:///'
#
unless ENV['DATABASE_URL'] == 'nulldb:///'
  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end
end

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted, this block will be run. If you are using the `preload_app!`
# option, you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, as Ruby
# cannot share connections between processes.
#
on_worker_boot do
  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['MAX_THREADS'] || 16
    ActiveRecord::Base.establish_connection(config)
  end
end
