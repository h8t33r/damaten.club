role :app, %w(hosting_hater@cobalt.locum.ru)
role :web, %w(hosting_hater@cobalt.locum.ru)
role :db, %w(hosting_hater@cobalt.locum.ru)

set :ssh_options, forward_agent: true
set :rails_env, :production
