set :deploy_to, '/home/ubuntu/apps/intranet'
server '18.224.219.66', user: 'ubuntu', roles: %w{app db web}
