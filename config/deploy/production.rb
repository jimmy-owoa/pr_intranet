set :stage, :production
set :deploy_to, '/home/ubuntu/prod_helpcenter'
set :branch, 'master-compass-helpcenter'
set :rails_env, 'production'
server "18.233.138.39", user: 'ubuntu', roles: %w{app db web}
