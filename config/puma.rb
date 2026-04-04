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
directory '/var/www/crm_2software'
rackup "/var/www/crm_2software/config.ru"
environment 'production'

pidfile "/var/www/crm_2software/shared/tmp/pids/puma.pid"
state_path "/var/www/crm_2software/shared/tmp/pids/puma.state"
stdout_redirect "/var/www/crm_2software/shared/log/puma.stdout.log", "/var/www/crm_2software/shared/log/puma.stderr.log", true

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

workers ENV.fetch("WEB_CONCURRENCY") { 2 }

bind "tcp://127.0.0.1:3001"

plugin :tmp_restart
