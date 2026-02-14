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

workers ENV.fetch("WEB_CONCURRENCY") { 2 }

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

preload_app!

rackup DefaultRackup

environment ENV.fetch("RAILS_ENV") { "development" }

port ENV.fetch("PORT") { 3000 }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
