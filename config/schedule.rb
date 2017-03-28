set :rbenv_root, "/home/deploy/.rbenv"
env :PATH, "#{rbenv_root}/shims:#{rbenv_root}/bin:/bin:/usr/bin"

set :output, "/home/deploy/apps/pairup-api/current/log/cron_log.log"

every 1.hour do
  rake "activites:import"
  rake "notify_about_subscription_expiration:after_24_hours"
end

every 1.day, at: "12:00am" do
  rake "activites:import_last_3_days"
  rake "notify_about_subscription_expiration:after_10_days"
end
