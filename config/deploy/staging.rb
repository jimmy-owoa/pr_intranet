set :deploy_to, "/home/ubuntu/apps/prod_intranet"
set :branch, "develop"
server "18.219.170.127", user: "ubuntu", roles: %w{app db web}
