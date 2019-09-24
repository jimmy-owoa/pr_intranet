set :deploy_to, '/home/ubuntu/apps/qa_intranet'
set :branch, "develop"
server 'adminqa.elmejorlugarparatrabajar.cl', user: 'ubuntu', roles: %w{app db web}
