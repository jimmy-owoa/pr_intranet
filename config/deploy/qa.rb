set :deploy_to, '/home/ubuntu/apps/qa_intranet'
set :branch, "develop"
server 'ec2-18-217-48-255.us-east-2.compute.amazonaws.com', user: 'ubuntu', roles: %w{app db web}
