set :deploy_to, '/home/ubuntu/apps/prod_intranet'
set :branch, 'develop'
server 'admin.elmejorlugarparatrabajar.cl', user: 'ubuntu', roles: %w{app db web}
