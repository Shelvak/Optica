lock "3.8.1"

set :application, "optica"
set :repo_url, "https://github.com/Shelvak/Optica.git"


set :branch, 'master'

set :deploy_to, "/var/rails/optica"

append :linked_files, "config/app_config.yml", "config/secrets.yml", 'app/views/layouts/application.html.erb', 'prod.wsdl'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "private", 'certs'
