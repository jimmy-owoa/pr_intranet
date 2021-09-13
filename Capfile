set :rbenv_type, :user
set :rbenv_ruby, "2.5.9"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rbenv'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

set :rbenv_type, :user
set :rbenv_ruby, "2.5.9"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
