set :application, "optica"
default_run_options[:pty] = true
set :repository,  "git@github.com:Shelvak/Optica.git"
set :deploy_to, '/home/rotsen/Documentos/rails/www/optica/'
set :scm, :git
set :user, 'rotsen'
set :scm_passphrase, '12452'
set :deploy_via, :remote_cache
set :rails_env, :production


# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, 'master'
role :web, "localhost"                          # Your HTTP server, Apache/etc
role :app, "localhost"                          # This may be the same as your `Web` server
role :db,  "localhost", :primary => true # This is where Rails migrations will run
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

end