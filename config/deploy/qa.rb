set :deploy_to, '/home/ubuntu/apps/qa_intranet'
set :branch, "master"
server '18.224.219.66', user: 'ubuntu', roles: %w{app db web}
