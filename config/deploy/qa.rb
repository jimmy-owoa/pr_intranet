set :deploy_to, "/home/ubuntu/apps/qa_intranet"
set :branch, "develop"
server "qaintranet.exaconsultores.cl", user: "ubuntu", roles: %w{app db web}
