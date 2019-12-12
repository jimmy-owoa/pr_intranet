set :deploy_to, "/home/ubuntu/apps/prod_intranet"
set :branch, "develop"
server "intranet.exaconsultores.cl", user: "ubuntu", roles: %w{app db web}
