#Wheneverize production =)
require 'whenever/capistrano'
set :whenever_command, "bundle exec whenever"
require 'bundler/capistrano'


set :application, "optica"
default_run_options[:pty] = true
set :repository,  "git@github.com:Shelvak/Optica.git"
set :deploy_to, '/var/www/optica/'
#set :deploy_to, '/home/rotsen/ruby/www/optica/'
set :scm, :git
set :user, 'marcela'
#set :user, 'rotsen'
set :deploy_via, :remote_cache
#set :port, 26
#set :rails_env, :production
set :use_sudo, false

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, 'master'
role :web, "optica-palpa.no-ip.org"                          # Your HTTP server, Apache/etc
role :app, "optica-palpa.no-ip.org"                          # This may be the same as your `Web` server
role :db,  "optica-palpa.no-ip.org", :primary => true # This is where Rails migrations will run
#role :web, "rotsenweb.no-ip.org"                          # Your HTTP server, Apache/etc
#role :app, "rotsenweb.no-ip.org"                          # This may be the same as your `Web` server
#role :db,  "rotsenweb.no-ip.org", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc 'Creates the symlinks for the shared folders'                            
  task :create_shared_symlinks, roles: :app, except: { no_release: true } do    
    shared_paths = [['config', 'app_config.yml']]                  
                                                                                
    shared_paths.each do |path|                                                 
      shared_files_path = File.join(shared_path, *path)                         
      release_files_path = File.join(release_path, *path)                       
                                                                                
      run "ln -s #{shared_files_path} #{release_files_path}"                    
    end                                                                         
  end
end
