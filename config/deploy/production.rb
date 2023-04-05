set :stage, :production
set :deploy_to, '/home/ubuntu/compass-helpcenter'
set :branch, 'master-compass-helpcenter'
set :rails_env, 'production'
server "adminhc.redexa.cl", user: 'ubuntu', roles: %w{app db web}
