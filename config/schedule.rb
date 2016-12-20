set :rbenv_root, "/home/deploy/.rbenv"
env :PATH, "#{rbenv_root}/shims:#{rbenv_root}/bin:/bin:/usr/bin"

set :output, "/home/deploy/apps/pairup-api/current/log/cron_log.log"

every 1.hour do
  rake "activites:import"
end
