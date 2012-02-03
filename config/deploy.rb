#Wheneverize production =)
require 'whenever/capistrano'
set :whenever_command, "bundle exec whenever"
require 'bundler/capistrano'


set :application, "optica"
default_run_options[:pty] = true
set :repository,  "git@github.com:Shelvak/Optica.git"
set :deploy_to, '/var/www/optica/'
set :scm, :git
set :user, 'marcela'
set :deploy_via, :remote_cache
#set :port, 26
#set :rails_env, :production
set :use_sudo, false

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, 'master'
role :web, "optica-palpa.no-ip.org"                          # Your HTTP server, Apache/etc
role :app, "optica-palpa.no-ip.org"                          # This may be the same as your `Web` server
role :db,  "optica-palpa.no-ip.org", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  # desc "reload the database with seed data"
	task :seed do
		run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
	end
# after "deploy:update_code", "bundle install"
# task "bundle install", :roles => :app do
# run "cd #{release_path} && bundle install"
# end
    #update Cron
    desc "Update the crontab file"  
      task :update_crontab, :roles => :db do  
        run "cd #{release_path} && whenever --update-crontab #{application}"  
      end  
end