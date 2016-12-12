lock "3.6.1"

set :application, "pairup-api"
set :repo_url, "git@github.com:fs/b-designworks.git"
set :deploy_to, "/home/deploy/apps/pairup-api"
set :keep_releases, 5

append :linked_files, "config/database.yml", ".env"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle"

set :puma_init_active_record, true

set :rbenv_type, :user
set :rbenv_ruby, "2.3.1"
