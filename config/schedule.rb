set :output, "/home/deploy/apps/pairup-api/current/log/cron_log.log"

every 1.hour do
  rake "activites:import"
end
