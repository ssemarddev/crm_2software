#workers ENV.fetch("WEB_CONCURRENCY") { 2 }
#threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
#threads threads_count, threads_count

#preload_app!

#rackup      DefaultRackup
#port        ENV.fetch("PORT") { 3000 }
#environment ENV.fetch("RAILS_ENV") { "production" }

#pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

#on_worker_boot do
#  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
#end

#bind "unix:///home/batisoftware/crm_2software/tmp/sockets/puma.sock"

# config/puma.rb
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5).to_i
threads threads_count, threads_count

environment ENV.fetch("RAILS_ENV") { "development" }

port ENV.fetch("PORT", 3000)

pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

plugin :tmp_restart

if ENV["RAILS_ENV"] == "production"
  workers ENV.fetch("WEB_CONCURRENCY", 2).to_i

  app_dir = ENV.fetch("APP_DIR", File.expand_path("..", __dir__))
  directory app_dir

  stdout_redirect(
    ENV.fetch("PUMA_STDOUT_LOG", "log/puma.stdout.log"),
    ENV.fetch("PUMA_STDERR_LOG", "log/puma.stderr.log"),
    true
  )
end
