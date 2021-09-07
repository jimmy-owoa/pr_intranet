set :deploy_to, "/home/ubuntu/apps/prod_helpcenter"
set :branch, "master-compass-helpcenter"
set :rails_env, 'production'
server "3.235.8.128", user: "ubuntu", roles: %w{app db web}
