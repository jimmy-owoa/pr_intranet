
# require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'

require 'capistrano/rbenv'
require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require "capistrano/rails"
require "capistrano/bundler"
require "capistrano/puma"
install_plugin Capistrano::Puma

set :rbenv_type, :user
set :rbenv_ruby, "2.5.9"
# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
